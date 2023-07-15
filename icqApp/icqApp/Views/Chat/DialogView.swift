//
//  DialogView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import FirebaseAuth
import SwiftUI

struct DialogView: View {
    let chatRoom: ChatRoom
    @State private var text: String = ""
    @EnvironmentObject private var chatManager: ChatRoomsManager

    var body: some View {
        VStack {
            Text(chatRoom.subject).font(.title)
            ScrollViewReader { proxy in
                ChatMessageListView(messages: chatManager.chatMessages)
                    .onChange(of: chatManager.chatMessages) { _ in
                        if !chatManager.chatMessages.isEmpty {
                            let theLastMessage = chatManager.chatMessages[chatManager.chatMessages.endIndex - 1]
                            withAnimation {
                                proxy.scrollTo(theLastMessage.id, anchor: .bottom)
                            }
                        }
                    }
            }

            Spacer()
            TextField("Enter your message", text: $text)
            Button("Send") {
                Task {
                    do {
                        guard let user = Auth.auth().currentUser else { return }
                        let chatMessage = ChatMessage(documentId: UUID().uuidString, text: text, userId: user.uid, dateCreated: Date(), displayName: user.displayName ?? "guest")
                        try await chatManager.sendMessage(message: chatMessage, chatRoom: chatRoom)
                        text = ""
                    } catch {
                        debugPrint(error)
                    }
                }
            }
        }
        .padding(.horizontal, MasterPage.Constant.Space.horizontalPadding)
        .onAppear {
            Task {
                try await chatManager.listenChatMessages(in: chatRoom)
            }
        }
        .onDisappear {
            chatManager.detachFirebaseListener()
        }
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        DialogView(chatRoom: ChatRoom(subject: "Music")).environmentObject(ChatRoomsManager())
    }
}
