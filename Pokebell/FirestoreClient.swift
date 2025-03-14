//
//  FirestoreClient.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/29.
//

import Foundation
import FirebaseFirestore

let myNumber = "00000"

class FirestoreClient {
    
    static let messageRef = Firestore.firestore().collection("messages")
    
    static func postMessage(text: String, receiver: String) async throws {
        let message = Message(sender: myNumber, receiver: receiver, text: text, date: Timestamp())
        let encodedMessage = try Firestore.Encoder().encode(message)
        try await messageRef.addDocument(data: encodedMessage)
    }
    
    static func fetchMessage() async throws -> [Message] {
        try await messageRef.whereField("receiver", isEqualTo: myNumber).order(by: "date", descending: true).getDocuments().documents.compactMap { try? $0.data(as: Message.self) }
    }
}
