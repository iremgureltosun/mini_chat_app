//
//  SignupView.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import FirebaseAuth
import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var displayName: String = ""
    @State private var errorMessage: String = ""
    @EnvironmentObject private var userManager: UserManager
    @Binding private var presentLogin: Bool

    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace && !displayName.isEmptyOrWhiteSpace
    }

    init(presentLogin: Binding<Bool>) {
        _presentLogin = presentLogin
    }

    var body: some View {
        VStack {
            Text("Register").font(.title).foregroundColor(.white)
            if !errorMessage.isEmptyOrWhiteSpace {
                Text(errorMessage).foregroundColor(.white)
            }
            Form {
                TextField("Email", text: $email).textInputAutocapitalization(.never)
                SecureField("Password", text: $password).textInputAutocapitalization(.never)
                TextField("Display Name", text: $displayName).textInputAutocapitalization(.never)

                HStack {
                    Group {
                        Button("Signup") {
                            Task {
                                await signUp()
                            }
                        }
                        .disabled(!isFormValid)

                        Spacer()

                        Button("Already have an account?") {
                            // Activate login view
                            presentLogin = true
                        }
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func signUp() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await userManager.updateDisplayName(for: result.user, displayName: displayName)
            // Activate login view
            presentLogin = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(presentLogin: .constant(false))
            .environmentObject(UserManager())
    }
}
