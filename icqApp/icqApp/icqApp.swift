//
//  icqApp.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import Firebase
import FirebaseAuth
import SwiftUI
import UIKit

@main
struct icqApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = ApplicationManager.shared
    @StateObject private var userManager = UserManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                ZStack {
                    if Auth.auth().currentUser != nil {
                        MainView()

                    } else {
                        LaunchView()
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        HomeView()

                    case .chat:
                        MainView()

                    case .settings:
                        SettingsView()
                    }
                }
            }
            .environmentObject(appState)
            .environmentObject(userManager)
        }
    }
}
