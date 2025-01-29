//
//  Message.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/29.
//


import Foundation
import FirebaseFirestore

struct Message: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var sender: String
    var receiver: String
    var text: String
    var date: Timestamp
}

