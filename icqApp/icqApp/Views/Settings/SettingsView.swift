//
//  SettingsView.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.08.2023.
//

import FirebaseAuth
import FirebaseStorage
import SwiftUI

struct SettingsConfig {
    var showPhotoOptions: Bool = false
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var displayName: String = ""
}

struct SettingsView: View {
    @State private var showSuccessDialog: Bool = false
    private let title: String = "Congratulations!"
    private let description: String = "Your profile picture is updated successfully"
    @State private var settingsConfig = SettingsConfig()
    @FocusState var isEditing: Bool
    @EnvironmentObject private var userManager: UserManager
    @EnvironmentObject private var appManager: ApplicationManager

    @State private var currentPhotoURL: URL? = Auth.auth().currentUser?.photoURL

    var displayName: String {
        guard let currentUser = Auth.auth().currentUser else { return StaticKeywords.guest }
        return currentUser.displayName ?? StaticKeywords.guest
    }

    var body: some View {
        NavigationView {
            VStack {
                AsyncImage(url: currentPhotoURL) { image in
                    image.rounded()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .rounded()
                }.onTapGesture {
                    settingsConfig.showPhotoOptions = true
                }.confirmationDialog("Select", isPresented: $settingsConfig.showPhotoOptions) {
                    Button("Camera") {
                        settingsConfig.sourceType = .camera
                    }

                    Button("Photo Library") {
                        settingsConfig.sourceType = .photoLibrary
                    }
                }

                TextField(settingsConfig.displayName, text: $settingsConfig.displayName)
                    .textFieldStyle(.roundedBorder)
                    .focused($isEditing)
                    .textInputAutocapitalization(.never)

                Spacer()
            }
            .sheet(item: $settingsConfig.sourceType, content: { sourceType in
                ImagePicker(image: $settingsConfig.selectedImage, sourceType: sourceType)
            })
            .onChange(of: settingsConfig.selectedImage, perform: { image in

                // resize the image
                guard let img = image else { return }
                let resizedImage = img.aspectFittedToHeight(100)
                guard let imageData = resizedImage.pngData() else { return }

                // upload the image to Firebase Storage to get the url
                Task {
                    guard let currentUser = Auth.auth().currentUser else { return }
                    let filename = "\(currentUser.uid).png"

                    do {
                        let url = try await Storage.storage().uploadData(for: filename, data: imageData, bucket: .photos)
                        try await userManager.updatePhotoURL(for: currentUser, photoURL: url)
                        currentPhotoURL = url
                        showSuccessDialog = true

                    } catch {
                        appManager.errorWrapper = ErrorWrapper(error: error, guidance: error.localizedDescription)
                    }
                }

            })
            .padding()
            .onAppear {
                settingsConfig.displayName = displayName
            }
            .alert(isPresented: $showSuccessDialog) {
                Alert(title: Text(title), message: Text(description), dismissButton: .default(Text("Got it!")))
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let currentUser = Auth.auth().currentUser else { return }
                        Task {
                            do {
                                try await userManager.updateDisplayName(for: currentUser, displayName: settingsConfig.displayName)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserManager())
    }
}
