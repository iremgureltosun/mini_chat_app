//
//  AddNewRoomView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import SwiftUI

struct AddNewChatRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var chatRoomsManager: GroupsManager
    @State private var subject: String = ""

    private var isFormValid: Bool {
        !subject.isEmptyOrWhiteSpace
    }

    private func saveRoom() async throws {
        let room = ChatGroup(subject: subject)
        try await chatRoomsManager.save(chatRoom: room)
        dismiss()
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Room Subject", text: $subject)
                }
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Room")
                        .bold()
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        Task {
                            do {
                                try await saveRoom()
                            } catch {
                                debugPrint(error)
                            }
                        }
                    }.disabled(!isFormValid)
                }
            }

        }.padding()
    }
}

struct AddNewChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddNewChatRoomView()
                .environmentObject(GroupsManager())
        }
    }
}
