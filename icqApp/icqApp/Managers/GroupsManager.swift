//
//  GroupManager.swift
//  icqApp
//
//  Created by Tosun, Irem on 11.07.2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

@MainActor
class GroupsManager: ObservableObject {
    @Published var chatRooms: [ChatGroup] = []
    @Published var chatMessages: [ChatMessage] = []

    let db = Firestore.firestore()
    let collection: CollectionReference
    var firestoreListener: ListenerRegistration?

    init() {
        collection = db.collection(DBCollections.groups)
    }

    func fetchChatRooms() async throws {
        let snapshot = try await collection.getDocuments()

        chatRooms = snapshot.documents.compactMap { snapshot in
            // we need to get a chat room based on snapshot
            ChatGroup.fromSnapshot(snapshot: snapshot)
        }
    }

    func save(chatRoom: ChatGroup) async throws {
        var docRef: DocumentReference?
        docRef = try await collection
            .addDocument(data: chatRoom.toDictionary())
        if let docRef {
            var newGroup = chatRoom
            newGroup.documentId = docRef.documentID
            chatRooms.append(newGroup)
        }
    }

    func sendMessage(message: ChatMessage, chatRoom: ChatGroup) async throws {
        guard let roomDocumentId = chatRoom.documentId else { return }
        try await collection.document(roomDocumentId)
            .collection(DBCollections.messages)
            .addDocument(data: message.toDictionary())
    }

    func listenChatMessages(in chatRoom: ChatGroup) async throws {
        chatMessages.removeAll()
        guard let documentId = chatRoom.documentId else { return }
        firestoreListener = db.collection(DBCollections.groups)
            .document(documentId)
            .collection(DBCollections.messages)
            .order(by: "dateCreated", descending: false)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot")
                    return
                }
                snapshot.documentChanges.forEach { change in
                    if change.type == .added {
                        if let message = ChatMessage.fromSnapshot(snapshot: change.document) {
                            self?.chatMessages.append(message)
                        }
                    }
                }
            }
    }

    func detachFirebaseListener() {
        firestoreListener?.remove()
    }
}
