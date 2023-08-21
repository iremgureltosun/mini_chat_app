//
//  ChatMessage.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct ChatMessage: Codable, Identifiable, Equatable {
    var messageOwnerIsMe: Bool {
        guard let loggedInUserId = Auth.auth().currentUser?.uid else { return false }
        return uid == loggedInUserId
    }

    var documentId: String?
    let text: String
    let uid: String
    var dateCreated = Date()
    let displayName: String
    var profilePhotoURL: String = ""
    var attachmentPhotoURL: String = ""

    var id: String {
        documentId ?? UUID().uuidString
    }

    var displayProfilPhotoURL: URL? {
        profilePhotoURL.isEmpty ? nil : URL(string: profilePhotoURL)
    }

    var displayAttachmentPhotoURL: URL? {
        attachmentPhotoURL.isEmpty ? nil : URL(string: attachmentPhotoURL)
    }
}

extension ChatMessage {
    func toDictionary() -> [String: Any] {
        return [
            DBCollections.ChatMessage.text: text,
            DBCollections.ChatMessage.uid: uid,
            DBCollections.ChatMessage.dateCreated: dateCreated,
            DBCollections.ChatMessage.displayName: displayName,
            DBCollections.ChatMessage.profilePhotoURL: profilePhotoURL,
            DBCollections.ChatMessage.attachmentPhotoURL: attachmentPhotoURL,
        ]
    }

    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let dictionary = snapshot.data()
        guard let text = dictionary[DBCollections.ChatMessage.text] as? String,
              let uid = dictionary[DBCollections.ChatMessage.uid] as? String,
              let dateCreated = (dictionary[DBCollections.ChatMessage.dateCreated] as? Timestamp)?.dateValue(),
              let displayName = dictionary[DBCollections.ChatMessage.displayName] as? String,
              let profilePhotoURL = dictionary[DBCollections.ChatMessage.profilePhotoURL] as? String,
              let attachmentPhotoURL = dictionary[DBCollections.ChatMessage.attachmentPhotoURL] as? String
        else {
            return nil
        }

        return ChatMessage(documentId: snapshot.documentID, text: text, uid: uid, dateCreated: dateCreated, displayName: displayName, profilePhotoURL: profilePhotoURL, attachmentPhotoURL: attachmentPhotoURL)
    }
}
