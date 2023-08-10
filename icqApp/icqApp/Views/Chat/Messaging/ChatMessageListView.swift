//
//  ChatMessageListView.swift
//  icqApp
//
//  Created by Tosun, Irem on 12.07.2023.
//

import SwiftUI

struct ChatMessageListView: View {
    let messages: [ChatMessage]

    var body: some View {
        ScrollView {
            ZStack {
                Image("room")
                    .resizable()

                VStack {
                    ForEach(messages) { message in
                        VStack {
                            HStack {
                                if message.messageOwnerIsMe { Spacer() }
                                ChatMessageView(chatMessage: message, direction: message.messageOwnerIsMe ? .right : .left, color: message.messageOwnerIsMe ? .green : .blue)
                                if !message.messageOwnerIsMe {
                                    Spacer()
                                }
                            }
                            Spacer().frame(height: 20)
                                .id(message.id)
                        }
                    }.listRowSeparator(.hidden)
                }
                .padding(.horizontal, MasterPage.Constant.Space.horizontalPadding)
            }

        }.padding(.bottom, 60)
    }
}

struct ChatMessageListView_Previews: PreviewProvider {
    static var previews: some View {
        let messages: [ChatMessage] = []
        ChatMessageListView(messages: messages)
    }
}
