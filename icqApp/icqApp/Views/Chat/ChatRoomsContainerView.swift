//
//  ChatRoomsContainerView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import SwiftUI

struct ChatRoomsContainerView: View {
    @State private var isPresented: Bool = false
    @EnvironmentObject private var chatRoomsManager: ChatRoomsManager

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("New Room") {
                    isPresented = true
                }
            }

            List(chatRoomsManager.chatRooms) { room in
                NavigationLink {
                    DialogView(chatRoom: room)
                        .environmentObject(ChatRoomsManager())
                } label: {
                    HStack {
                        Image(systemName: "person.2")
                        Text(room.subject)
                    }
                }
            }
            Spacer()
        }

        .task {
            do {
                try await chatRoomsManager.fetchChatRooms()
            } catch {
                print(error)
            }
        }
        .padding()
        .sheet(isPresented: $isPresented) {
            AddNewChatRoomView()
        }
    }
}

struct ChatRoomsContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomsContainerView()
            .environmentObject(ChatRoomsManager())
    }
}
