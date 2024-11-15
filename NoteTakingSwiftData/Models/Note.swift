//
//  Notes.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 21/09/2024.
//

import Foundation
import SwiftData

@Model class Note: Identifiable {
    @Attribute(.unique) var id: UUID
    var content: String
    var isDone: Bool
    var dateAdded: Date
    var category: Category?
    
    init(content: String, isDone: Bool, dateAdded: Date = Date(), category: Category? = nil) {
        self.id = UUID()
        self.content = content
        self.isDone = isDone
        self.dateAdded = dateAdded
        self.category = category
    }
}
