import Foundation
@preconcurrency import MultipeerConnectivity

/// Local-network multiplayer, no server: every device both advertises and
/// browses for the same room ID over Bonjour, connecting directly to every
/// other device it finds — a full mesh, not a hub-and-spoke. That's what
/// makes host migration possible: if any one participant disappears, the
/// rest are still directly connected to each other and can independently
/// agree on a new host (see `MultiplayerRoomViewModel.computedHostID`).
/// Nothing here ever leaves the local network.
@MainActor
final class MultipeerSessionTransport: NSObject, SessionTransport {
    private static let serviceType = "riskonacci-p2p"

    let localParticipantID = UUID()
    private var localNickname = ""
    private var roomID = ""

    private var peerID: MCPeerID!
    // MCSession's own delegate dispatch already serializes callbacks for a
    // given session; reading the reference itself off the main actor here
    // just satisfies the compiler for the didReceiveInvitation callback
    // below, which needs to reply synchronously rather than after an actor
    // hop.
    private nonisolated(unsafe) var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?

    private var peerUUIDs: [MCPeerID: UUID] = [:]

    var onReceive: ((SessionMessage, UUID) -> Void)?
    var onPeerConnected: ((UUID, String) -> Void)?
    var onPeerDisconnected: ((UUID) -> Void)?

    func startHosting(roomID: String, nickname: String) {
        connect(roomID: roomID, nickname: nickname)
    }

    func join(roomID: String, nickname: String) {
        connect(roomID: roomID, nickname: nickname)
    }

    private func connect(roomID: String, nickname: String) {
        self.roomID = roomID
        self.localNickname = nickname
        let peerID = MCPeerID(displayName: nickname)
        self.peerID = peerID
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        self.session = session

        let discoveryInfo = ["roomID": roomID, "uuid": localParticipantID.uuidString]

        let advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: Self.serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        self.advertiser = advertiser

        let browser = MCNearbyServiceBrowser(peer: peerID, serviceType: Self.serviceType)
        browser.delegate = self
        browser.startBrowsingForPeers()
        self.browser = browser
    }

    func send(_ message: SessionMessage) {
        guard let session, !session.connectedPeers.isEmpty else { return }
        guard let data = try? JSONEncoder().encode(message) else { return }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }

    func stop() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session?.disconnect()
        advertiser = nil
        browser = nil
        peerUUIDs = [:]
    }

    private func sendHello(to peers: [MCPeerID]) {
        let hello = SessionParticipant(id: localParticipantID, nickname: localNickname)
        guard let data = try? JSONEncoder().encode(SessionMessage.hello(hello)) else { return }
        try? session.send(data, toPeers: peers, with: .reliable)
    }
}

extension MultipeerSessionTransport: MCSessionDelegate {
    nonisolated func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        Task { @MainActor in
            switch state {
            case .connected:
                self.sendHello(to: [peerID])
            case .notConnected:
                if let uuid = self.peerUUIDs[peerID] {
                    self.peerUUIDs[peerID] = nil
                    self.onPeerDisconnected?(uuid)
                }
            default:
                break
            }
        }
    }

    nonisolated func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = try? JSONDecoder().decode(SessionMessage.self, from: data) else { return }
        Task { @MainActor in
            if case .hello(let participant) = message {
                self.peerUUIDs[peerID] = participant.id
                self.onPeerConnected?(participant.id, participant.nickname)
            }
            if let uuid = self.peerUUIDs[peerID] {
                self.onReceive?(message, uuid)
            }
        }
    }

    nonisolated func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {}

    nonisolated func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {}

    nonisolated func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?
    ) {}
}

extension MultipeerSessionTransport: MCNearbyServiceAdvertiserDelegate {
    nonisolated func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        invitationHandler(true, session)
    }
}

extension MultipeerSessionTransport: MCNearbyServiceBrowserDelegate {
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        Task { @MainActor in
            guard info?["roomID"] == self.roomID else { return }
            guard let session = self.session else { return }
            guard let remoteUUIDString = info?["uuid"] else { return }

            // Both sides discover each other independently — only the
            // lexicographically smaller UUID initiates the invite, so
            // exactly one connection attempt happens instead of two
            // racing ones.
            guard self.localParticipantID.uuidString < remoteUUIDString else { return }

            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 15)
        }
    }

    nonisolated func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
}
