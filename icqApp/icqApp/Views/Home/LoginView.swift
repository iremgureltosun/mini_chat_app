//
//  LoginForm.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @EnvironmentObject private var appManager: ApplicationManager

    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace
    }

    @Binding private var presentLogin: Bool

    init(presentLogin: Binding<Bool>) {
        _presentLogin = presentLogin
    }

    var body: some View {
        VStack {
            Text("Login").font(.title).foregroundColor(.black)
            if !errorMessage.isEmptyOrWhiteSpace {
                Text(errorMessage).foregroundColor(.white)
            }
            Form {
                TextField("Email", text: $email).textInputAutocapitalization(.never)
                SecureField("Password", text: $password).textInputAutocapitalization(.never)

                HStack {
                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        Text("Login")
                    }
                    .disabled(!isFormValid)

                    Spacer()

                    Button(action: {
                        // Activate register view
                        presentLogin = false
                    }) {
                        Text("Don't you have an account?")
                    }
                }
            }

            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, MasterPage.Constant.Space.small)
        .navigationBarBackButtonHidden(true)
    }

    private func login() async {
        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            appManager.routes.append(.chat)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(presentLogin: .constant(false))
    }
}
