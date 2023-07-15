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
    @EnvironmentObject private var appState: ApplicationManager
   
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace
    }

    @Binding private var presentLogin: Bool

    init(presentLogin: Binding<Bool>) {
        _presentLogin = presentLogin
    }

    var body: some View {
        VStack {
            Text("Login").font(.title).foregroundColor(.white)
            if !errorMessage.isEmptyOrWhiteSpace {
                Text(errorMessage).foregroundColor(.white)
            }
            Form {
                TextField("Email", text: $email).textInputAutocapitalization(.never)
                SecureField("Password", text: $password).textInputAutocapitalization(.never)

                HStack {
                    Group {
                        Button("Login") {
                            Task {
                                await login()
                            }
                        }
                        .disabled(!isFormValid)
                        Spacer()
                        Button("Don't you have an account?") {
                            // Activate register view
                            presentLogin = false
                        }
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func login() async {
        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            appState.routes.append(.chat)
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
