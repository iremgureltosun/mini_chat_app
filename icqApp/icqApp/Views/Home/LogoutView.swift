//
//  LogoutView.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.08.2023.
//

import FirebaseAuth
import SwiftUI

struct LogoutView: View {
    @EnvironmentObject private var appManager: ApplicationManager

    var body: some View {
        Image("logout").ignoresSafeArea()
            .onAppear {
                logout()
            }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            _ = appManager.routes.popLast()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
