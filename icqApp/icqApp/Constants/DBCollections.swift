//
//  DbCollections.swift
//  icqApp
//
//  Created by Tosun, Irem on 10.08.2023.
//

import Foundation

enum StaticKeywords {
    static let guest = "Guest"
}

enum DBCollections {
    static let groups = "groups"
    static let messages = "messages"

    enum ChatMessage {
        static let text = "text"
        static let uid = "uid"
        static let dateCreated = "dateCreated"
        static let displayName = "displayName"
        static let profilePhotoURL = "profilePhotoURL"
        static let attachmentPhotoURL = "attachmentPhotoURL"
    }

    enum ChatGroup {
        static let subject = "subject"
    }
}
