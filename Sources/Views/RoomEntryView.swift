import SwiftUI

/// Entry point for multiplayer: pick a nickname and a room type (nearby
/// Wi-Fi or online via CloudKit), then either host a new room (gets a fresh
/// 5-character code to share) or join one with a code from someone else.
struct RoomEntryView: View {
    @State private var room = MultiplayerRoomViewModel()
    @State private var nickname = ""
    @State private var joinCode = ""
    @State private var mode: Mode = .choosing
    @State private var roomKind: RoomKind = .local
    @State private var iCloudUnavailable = false

    private enum Mode {
        case choosing, joining
    }

    var body: some View {
        Group {
            if room.connectionState == .idle {
                entryForm
            } else {
                RoomView(room: room)
            }
        }
        .navigationTitle("Multiplayer")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            #if DEBUG
            if let name = DebugLaunchOptions.autoHostNickname, room.connectionState == .idle {
                nickname = name
                room.hostRoom(nickname: name, kind: DebugLaunchOptions.autoRoomKind)
            } else if let name = DebugLaunchOptions.autoJoinNickname,
                      let code = DebugLaunchOptions.autoJoinRoomID,
                      room.connectionState == .idle {
                nickname = name
                room.joinRoom(roomID: code, nickname: name, kind: DebugLaunchOptions.autoRoomKind)
            }
            #endif
        }
    }

    private func startIfPossible(_ action: @escaping () -> Void) {
        guard roomKind == .online else {
            action()
            return
        }
        Task {
            if await CloudKitAccountStatus.isAvailable() {
                action()
            } else {
                iCloudUnavailable = true
            }
        }
    }

    private var entryForm: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.accentColor)
                Text(roomKind == .local ? "Play together with people nearby" : "Play together, from anywhere")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 24)

            Picker("Room type", selection: $roomKind) {
                Text("Nearby").tag(RoomKind.local)
                Text("Online").tag(RoomKind.online)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if iCloudUnavailable {
                Text("Sign in to iCloud in Settings to play online.")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            TextField("Your name", text: $nickname)
                .textFieldStyle(.plain)
                .padding()
                .glassEffect(.regular, in: .rect(cornerRadius: 16))
                .padding(.horizontal)

            if mode == .joining {
                TextField("Room code", text: $joinCode)
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 16))
                    .padding(.horizontal)
            }

            VStack(spacing: 14) {
                Button {
                    iCloudUnavailable = false
                    startIfPossible {
                        room.hostRoom(nickname: trimmedNickname, kind: roomKind)
                    }
                } label: {
                    Text("Host a room")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .contentShape(.rect)
                }
                .buttonStyle(.glassProminent)
                .disabled(trimmedNickname.isEmpty)

                if mode == .joining {
                    Button {
                        iCloudUnavailable = false
                        startIfPossible {
                            room.joinRoom(roomID: joinCode.uppercased(), nickname: trimmedNickname, kind: roomKind)
                        }
                    } label: {
                        Text("Join")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .contentShape(.rect)
                    }
                    .buttonStyle(.glass)
                    .disabled(trimmedNickname.isEmpty || !RoomID.isValid(joinCode))
                } else {
                    Button("Join a room instead") {
                        mode = .joining
                    }
                    .buttonStyle(.glass)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .frame(maxWidth: 480)
        .frame(maxWidth: .infinity)
    }

    private var trimmedNickname: String {
        nickname.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
