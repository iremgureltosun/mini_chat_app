//
//  ChatMessageInputView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.08.2023.
//

import SwiftUI
struct GroupDetailConfig {
    var chatText: String = ""
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var showOptions: Bool = false

    mutating func clearForm() {
        chatText = ""
        selectedImage = nil
    }

    var isValid: Bool {
        !chatText.isEmptyOrWhiteSpace || selectedImage != nil
    }
}

struct ChatMessageInputView: View {
    @Binding var groupDetailConfig: GroupDetailConfig
    @FocusState var isChatTextFieldFocused: Bool
    var onSendMessage: () -> Void

    var body: some View {
        HStack {
            Button {
                groupDetailConfig.showOptions = true
            } label: {
                Image(systemName: "plus")
            }

            TextField("Enter text here", text: $groupDetailConfig.chatText)
                .textFieldStyle(.roundedBorder)
                .focused($isChatTextFieldFocused)

            Button {
                if groupDetailConfig.isValid {
                    onSendMessage()
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.largeTitle)
                    .rotationEffect(Angle(degrees: 44))

            }.disabled(!groupDetailConfig.isValid)
        }
    }
}

struct ChatMessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageInputView(groupDetailConfig: .constant(GroupDetailConfig(chatText: "Hello World")), onSendMessage: { })
    }
}
