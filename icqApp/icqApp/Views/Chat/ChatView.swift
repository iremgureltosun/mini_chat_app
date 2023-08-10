//
//  ChatView.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import FirebaseAuth
import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var appState: ApplicationManager

    var body: some View {
        TabView {
            chatContainer
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }

            Text("Friends")
                .tabItem {
                    Label("Friends", systemImage: "face.smiling")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder var chatContainer: some View {
        ZStack {
            Image("lobby")
                .resizable().ignoresSafeArea()
            VStack {
                HStack {
                    if let userName = Auth.auth().currentUser?.displayName {
                        Text("Hello, \(userName)!")
                    }
                    Spacer()

                    if Auth.auth().currentUser != nil {
                        Button("Logout") {
                            logout()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .background(.clear)
                .padding(.horizontal, MasterPage.Constant.Space.horizontalPadding)
                .frame(height: 50)

                GroupsContainerView().environmentObject(GroupsManager())
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            _ = appState.routes.popLast()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(UserManager())
            .environmentObject(ApplicationManager.shared)
    }
}
