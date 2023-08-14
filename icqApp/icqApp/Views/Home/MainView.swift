//
//  ChatView.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import FirebaseAuth
import SwiftUI

struct MainView: View {
    @EnvironmentObject private var appManager: ApplicationManager

    var body: some View {
        TabView {
            chatContainer
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }

            LogoutView()
                .tabItem {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.forward")
                }
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder var chatContainer: some View {
        ZStack {
            Image("lobby")
                .resizable().ignoresSafeArea()
            VStack {
                GroupsContainerView().environmentObject(GroupsManager())
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(UserManager())
            .environmentObject(ApplicationManager.shared)
    }
}
