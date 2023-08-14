//
//  ChatRoom.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct ChatGroup: Codable, Identifiable {
    var documentId: String? = nil
    let subject: String

    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension ChatGroup {
    func toDictionary() -> [String: Any] {
        return [DBCollections.ChatGroup.subject: subject]
    }

    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatGroup? {
        let dictionary = snapshot.data()
        guard let subject = dictionary[DBCollections.ChatGroup.subject] as? String else {
            return nil
        }

        return ChatGroup(documentId: snapshot.documentID, subject: subject)
    }
}
