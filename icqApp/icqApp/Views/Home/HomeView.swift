//
//  HomeView.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import SwiftUI

struct HomeView: View {
    @State private var presentLogin: Bool = true
    var body: some View {
        VStack {
            Image("login").overlay {
                VStack {
                    if !presentLogin {
                        SignupView(presentLogin: $presentLogin)
                            .padding(.horizontal, MasterPage.Constant.Space.large)
                    } else {
                        LoginView(presentLogin: $presentLogin)
                            .padding(.horizontal, MasterPage.Constant.Space.large)
                    }
                    Spacer()
                }
                .padding(.horizontal, MasterPage.Constant.Space.medium)
                .padding(.top, 210)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserManager())
            .environmentObject(ApplicationManager.shared)
    }
}
