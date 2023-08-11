//
//  DialogView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import FirebaseAuth
import SwiftUI

struct DialogView: View {
    let chatRoom: ChatGroup
    @State private var text: String = ""
    @EnvironmentObject private var chatManager: GroupsManager
    @State private var groupDetailConfig = GroupDetailConfig()
    @FocusState private var isChatFieldFocused: Bool

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
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, MasterPage.Constant.Space.horizontalPadding)
        .overlay(alignment: .bottom) {
            ChatMessageInputView(groupDetailConfig: $groupDetailConfig, isChatTextFieldFocused: _isChatFieldFocused) {
                // send message
                Task {
                    do {
                        guard let user = Auth.auth().currentUser else { return }
                        let chatMessage = ChatMessage(documentId: UUID().uuidString, text: text, uid: user.uid, dateCreated: Date(), displayName: user.displayName ?? "guest", profilePhotoURL: user.photoURL?.absoluteString ?? "")
                        try await chatManager.sendMessage(message: chatMessage, chatRoom: chatRoom)
                        text = ""
                    } catch {
                        debugPrint(error)
                    }
                }
            }
        }
        .padding()
        .confirmationDialog("Options", isPresented: $groupDetailConfig.showOptions, actions: {
            Button("Camera"){
                groupDetailConfig.sourceType = .camera
            }
            Button("Photo Library"){
                groupDetailConfig.sourceType = .photoLibrary
            }
        })
        //Every time groupDetailConfig.sourceType changes, image picker gets activated
        .sheet(item: $groupDetailConfig.sourceType, content: { sourceType in
            ImagePicker(image: $groupDetailConfig.selectedImage, sourceType: sourceType)
        })
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
        DialogView(chatRoom: ChatGroup(subject: "Music")).environmentObject(GroupsManager())
    }
}
