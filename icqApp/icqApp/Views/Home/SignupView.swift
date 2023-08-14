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
    @EnvironmentObject private var appManager: ApplicationManager
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
            Text("Register").font(.title).foregroundColor(.black)
            Form {
                TextField("Email", text: $email).textInputAutocapitalization(.never)
                SecureField("Password", text: $password).textInputAutocapitalization(.never)
                TextField("Display Name", text: $displayName).textInputAutocapitalization(.never)

                HStack {
                    Button(action: {
                        Task {
                            await signUp()
                        }
                    }) {
                        Text("Signup")
                    }
                    .disabled(!isFormValid)

                    Spacer()

                    Button(action: {
                        // Activate login view
                        presentLogin = true
                    }) {
                        Text("Already have an account?")
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, MasterPage.Constant.Space.small)
        .navigationBarBackButtonHidden(true)
    }

    private func signUp() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await userManager.updateDisplayName(for: result.user, displayName: displayName)
            // Activate login view
            presentLogin = true
        } catch {
            appManager.errorWrapper = ErrorWrapper(error: error, guidance: error.localizedDescription)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(presentLogin: .constant(false))
            .environmentObject(UserManager())
    }
}
