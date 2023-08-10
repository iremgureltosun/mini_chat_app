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

    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension ChatMessage {
    func toDictionary() -> [String: Any] {
        return [
            "text": text,
            "uid": uid,
            "dateCreated": dateCreated,
            "displayName": displayName,
        ]
    }

    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let dictionary = snapshot.data()
        guard let text = dictionary["text"] as? String,
              let uid = dictionary["uid"] as? String,
              let dateCreated = (dictionary["dateCreated"] as? Timestamp)?.dateValue(),
              let displayName = dictionary["displayName"] as? String
        else {
            return nil
        }

        return ChatMessage(documentId: snapshot.documentID, text: text, uid: uid, dateCreated: dateCreated, displayName: displayName)
    }
}
