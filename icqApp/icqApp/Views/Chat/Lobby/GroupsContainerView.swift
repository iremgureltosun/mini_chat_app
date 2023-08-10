//
//  ChatRoomsContainerView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import SwiftUI

struct GroupsContainerView: View {
    @State private var isPresented: Bool = false
    @EnvironmentObject private var groupsManager: GroupsManager

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("New Room") {
                    isPresented = true
                }
                .foregroundColor(.orange)
                .buttonStyle(.bordered)
                .padding([.trailing, .top], MasterPage.Constant.Space.horizontalPadding)
            }

            List(groupsManager.chatRooms) { room in
                NavigationLink {
                    DialogView(chatRoom: room)
                        .environmentObject(GroupsManager())
                } label: {
                    HStack {
                        Group {
                            Image(systemName: "person.2")
                            Text(room.subject)
                        }.padding(.horizontal, MasterPage.Constant.Space.horizontalPadding)
                    }
                    .frame(height: 85)
                    .contentShape(Rectangle())
                }
                .padding(.trailing, MasterPage.Constant.Space.horizontalPadding)
                .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 8,
                    x: 0,
                    y: 4
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            }
            .listStyle(.plain)
            .background(.clear)
            Spacer()
        }
        .frame(height: 700)
        .contentShape(Rectangle())

        .padding(.horizontal, MasterPage.Constant.Space.medium)

        .task {
            do {
                try await groupsManager.fetchChatRooms()
            } catch {
                debugPrint(error)
            }
        }
        .sheet(isPresented: $isPresented) {
            AddNewChatRoomView()
        }
    }
}

struct ChatRoomsContainerView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsContainerView()
            .environmentObject(GroupsManager())
    }
}
