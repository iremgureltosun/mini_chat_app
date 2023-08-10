//
//  UserManager.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.07.2023.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@MainActor
class UserManager: ObservableObject {
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
    }

    func updatePhotoURL(for user: User, photoURL: URL) async throws {
        let request = user.createProfileChangeRequest()
        request.photoURL = photoURL
        try await request.commitChanges()

        // update UserInf for all messages
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["profilePhotoURL": photoURL.absoluteString])
    }

    private func updateUserInfoForAllMessages(uid: String, updatedInfo: [AnyHashable: Any]) async throws {
        let db = Firestore.firestore()

        let groupDocuments = try await db.collection(DBCollections.groups).getDocuments().documents

        for groupDoc in groupDocuments {
            let messages = try await groupDoc.reference.collection(DBCollections.messages)
                .whereField("uid", isEqualTo: uid)
                .getDocuments().documents

            for message in messages {
                try await message.reference.updateData(updatedInfo)
            }
        }
    }
}
