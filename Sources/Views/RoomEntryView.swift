import SwiftUI

/// Entry point for multiplayer: pick a nickname, then either host a new
/// room (gets a fresh 5-character code to share) or join one with a code
/// from someone else. Works the same whether everyone's on the same
/// Wi-Fi or scattered anywhere with a connection — and the same whether
/// the other player is on iPhone or Android — since every device just
/// talks to the same shared Firebase room.
struct RoomEntryView: View {
    @State private var room = MultiplayerRoomViewModel()
    @State private var nickname = ""
    @State private var joinCode = ""
    @State private var mode: Mode = .choosing

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
                room.hostRoom(nickname: name)
            } else if let name = DebugLaunchOptions.autoJoinNickname,
                      let code = DebugLaunchOptions.autoJoinRoomID,
                      room.connectionState == .idle {
                nickname = name
                room.joinRoom(roomID: code, nickname: name)
            }
            #endif
        }
    }

    private var entryForm: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.accentColor)
                Text("Play together, from anywhere")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 24)

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
                    room.hostRoom(nickname: trimmedNickname)
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
                        room.joinRoom(roomID: joinCode.uppercased(), nickname: trimmedNickname)
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
