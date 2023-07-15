//
//  ChatRoom.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatRoom: Codable, Identifiable {
    var documentId: String? = nil
    let subject: String

    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension ChatRoom {
    func toDictionary() -> [String: Any] {
        return ["subject": subject]
    }

    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatRoom? {
        let dictionary = snapshot.data()
        guard let subject = dictionary["subject"] as? String else {
            return nil
        }

        return ChatRoom(documentId: snapshot.documentID, subject: subject)
    }
}
