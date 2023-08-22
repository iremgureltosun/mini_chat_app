//
//  ChatMessageView.swift
//  icqApp
//
//  Created by Tosun, Irem on 12.07.2023.
//

import SwiftUI

struct ChatMessageView: View {
    let chatMessage: ChatMessage
    let direction: ChatMessageDirection
    let color: Color

    var body: some View {
        HStack {
            // profile photo

            if direction == .left {
                getProfilePhoto(for: chatMessage)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(chatMessage.displayName)
                    .opacity(0.8)
                    .font(.caption)
                    .foregroundColor(.white)

                // attachment photo URL
                if let attachmentPhotoURL = chatMessage.displayAttachmentPhotoURL {
                    AsyncImage(url: attachmentPhotoURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)

                    } placeholder: {
                        ProgressView("Loading...")
                    }
                }

                Text(chatMessage.text)
                Text(chatMessage.dateCreated, format: .dateTime)
                    .padding(.bottom, 10)
                    .font(.caption)
                    .opacity(0.4)
                    .frame(maxWidth: 200, alignment: .trailing)
            }.padding(8)
                .background(color)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))

        }.listRowSeparator(.hidden)
            .overlay(alignment: direction == .left ? .bottomLeading : .bottomTrailing) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(direction == .left ? 45 : -45))
                    .offset(x: direction == .left ? 30 : -30, y: 10)
                    .foregroundColor(color)
            }
        // profile photo

        if direction == .right {
            getProfilePhoto(for: chatMessage)
        }
    }

    @ViewBuilder
    private func getProfilePhoto(for _: ChatMessage) -> some View {
        if let profilePhotoURL = chatMessage.displayProfilPhotoURL {
            AsyncImage(url: profilePhotoURL) { image in
                image.rounded(width: 34, height: 34)
            } placeholder: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
            }
        } else {
            Image(systemName: "person.crop.circle")
                .font(.title)
        }
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(chatMessage: ChatMessage(documentId: "", text: "Test", uid: "QWERTY", dateCreated: Date(), displayName: "John"), direction: .right, color: .blue)
    }
}
