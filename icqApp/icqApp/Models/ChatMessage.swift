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
    var documentId: String
    let text: String
    let userId: String
    var dateCreated: Date
    let displayName: String
    var id: String {
        documentId
    }
}

extension ChatMessage {
    func toDictionary() -> [String: Any] {
        return ["text": text,
                "userId": userId,
                "dateCreated": dateCreated,
                "displayName": displayName,
                "documentId": documentId
        ]
    }

    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let dictionary = snapshot.data()
        guard let text = dictionary["text"] as? String,
              let userId = dictionary["userId"] as? String,
              let dateCreated = (dictionary["dateCreated"] as? Timestamp)?.dateValue(),
              let displayName = dictionary["displayName"] as? String,
              let documentId = dictionary["documentId"] as? String
        else {
            return nil
        }

        return ChatMessage(documentId: documentId, text: text, userId: userId, dateCreated: dateCreated, displayName: displayName)
    }

    var messageOwnerIsMe: Bool {
        guard let loggedInUserId = Auth.auth().currentUser?.uid else { return false }
        return userId == loggedInUserId
    }
}
