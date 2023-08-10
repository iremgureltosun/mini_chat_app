//
//  TopicsModel.swift
//  icqApp
//
//  Created by Tosun, Irem on 26.07.2023.
//

import FirebaseMessaging
import SwiftUI

class TopicsModel: ObservableObject {
    static let familyKey = "family"
    static let petsKey = "pets"
    @AppStorage(TopicsModel.familyKey) var family = false {
        didSet {
            updateSubscription(for: TopicsModel.familyKey, subscribed: family)
        }
    }

    @AppStorage(TopicsModel.petsKey) var pets = false {
        didSet {
            updateSubscription(for: TopicsModel.petsKey, subscribed: pets)
        }
    }

    private func updateSubscription(for topic: String, subscribed: Bool) {
        if subscribed {
            subscribe(to: topic)
        } else {
            unsubscribe(from: topic)
        }
    }

    private func subscribe(to topic: String) {
        Messaging.messaging().subscribe(toTopic: topic)
    }

    private func unsubscribe(from topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic)
    }
}
