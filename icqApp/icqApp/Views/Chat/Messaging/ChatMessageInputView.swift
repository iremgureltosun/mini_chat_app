//
//  ChatMessageInputView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.08.2023.
//

import SwiftUI
struct DialogConfig {
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
    @Binding var dialogConfig: DialogConfig
    @FocusState var isChatTextFieldFocused: Bool
    var onSendMessage: () -> Void

    var body: some View {
        HStack {
            Button {
                dialogConfig.showOptions = true
            } label: {
                Image(systemName: "plus")
            }

            TextField("Enter text here", text: $dialogConfig.chatText)
                .textFieldStyle(.roundedBorder)
                .focused($isChatTextFieldFocused)

            Button {
                if dialogConfig.isValid {
                    onSendMessage()
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.largeTitle)
                    .rotationEffect(Angle(degrees: 44))

            }.disabled(!dialogConfig.isValid)
        }
    }
}

struct ChatMessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageInputView(dialogConfig: .constant(DialogConfig(chatText: "Hello World")), onSendMessage: { })
    }
}
