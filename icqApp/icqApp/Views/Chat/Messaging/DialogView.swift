//
//  DialogView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import FirebaseAuth
import FirebaseStorage
import SwiftUI

struct DialogView: View {
    let chatRoom: ChatGroup
    @EnvironmentObject private var chatManager: GroupsManager
    @EnvironmentObject private var appState: ApplicationManager
    @State private var dialogConfig = DialogConfig()
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
        .confirmationDialog("Options", isPresented: $dialogConfig.showOptions, actions: {
            Button("Camera") {
                dialogConfig.sourceType = .camera
            }
            Button("Photo Library") {
                dialogConfig.sourceType = .photoLibrary
            }
        })
        // Every time groupDetailConfig.sourceType changes, image picker gets activated
        .sheet(item: $dialogConfig.sourceType, content: { sourceType in
            ImagePicker(image: $dialogConfig.selectedImage, sourceType: sourceType)
        })
        .overlay(alignment: .center, content: {
            if let selectedImage = dialogConfig.selectedImage {
                PreviewImageView(selectedImage: selectedImage) {
                    withAnimation {
                        dialogConfig.selectedImage = nil
                    }
                }
            }
        })
        .overlay(alignment: .bottom) {
            ChatMessageInputView(dialogConfig: $dialogConfig, isChatTextFieldFocused: _isChatFieldFocused) {
                // send message
                Task {
                    do {
                        try await sendMessage()
                    } catch {
                        debugPrint(error)
                    }
                }
            }.padding()
        }
        .onAppear {
            Task {
                try await chatManager.listenChatMessages(in: chatRoom)
            }
        }
        .onDisappear {
            chatManager.detachFirebaseListener()
        }
    }

    private func sendMessage() async throws {
        guard let user = Auth.auth().currentUser else { return }
        var chatMessage = ChatMessage(documentId: UUID().uuidString, text: dialogConfig.chatText, uid: user.uid, dateCreated: Date(), displayName: user.displayName ?? StaticKeywords.guest, profilePhotoURL: user.photoURL?.absoluteString ?? "")
        // If user selects an image, we add attachment to message!
        if let selectedImage = dialogConfig.selectedImage {
            guard let resizedImage = selectedImage.resize(to: CGSize(width: 600, height: 600)),
                  let imageData = resizedImage.pngData() else {
                return
            }
            let url = try await Storage.storage().uploadData(for: UUID().uuidString, data: imageData, bucket: .attachments)
            chatMessage.attachmentPhotoURL = url.absoluteString
        }
        appState.loadingState = .loading("Uploading image")

        try await chatManager.sendMessage(message: chatMessage, chatRoom: chatRoom)
        appState.loadingState = .idle
        clearFields()
    }

    private func clearFields() {
        dialogConfig.clearForm()
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        DialogView(chatRoom: ChatGroup(subject: "Music"))
            .environmentObject(ApplicationManager.shared)
            .environmentObject(GroupsManager())
    }
}
