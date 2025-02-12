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
    @Relationship(deleteRule: .cascade, inverse: \Category.belongsTo) var category: Category?
    
    // Transient property using the Date extension
    @Transient var formattedDate: String {
        dateAdded.formatDate()
    }
    
    @Transient var isSelected: Bool = false
    
    init(content: String, isDone: Bool, dateAdded: Date = Date(), category: Category? = nil) {
        self.id = UUID()
        self.content = content
        self.isDone = isDone
        self.dateAdded = dateAdded
        self.category = category
    }
}
