//
//  HomeView.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var presentLogin: Bool = false

    var body: some View {
        ZStack {
            Color(.purple).ignoresSafeArea(.all, edges: .all)

            VStack {
                if !presentLogin {
                    SignupView(presentLogin: $presentLogin)
                } else {
                    LoginView(presentLogin: $presentLogin)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserManager())
            .environmentObject(ApplicationManager())
    }
}
