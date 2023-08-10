//
//  ImagePicker.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.08.2023.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .camera

    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIImagePickerController, context _: Context) {}

    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: ImagePicker

        init(_ picker: ImagePicker) {
            self.picker = picker
        }

        func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                picker.image = uiImage
            }

            picker.dismiss()
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            picker.dismiss()
        }
    }
}
