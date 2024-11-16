//
//  NoteOneToMany.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 16/11/2024.
//

import SwiftData
import Foundation

@Model class NoteOneToMany: Identifiable {
    @Attribute(.unique) var id: UUID
    var content: String
    var isDone: Bool
    var dateTimeAdded: Date
    @Relationship(deleteRule: .cascade, inverse: \CategoryOneToMany.belongsTo) var categories: [CategoryOneToMany] = []
    
    init(content: String, isDone: Bool, categories: [CategoryOneToMany] = []) {
        self.id = UUID()
        self.content = content
        self.isDone = isDone
        self.dateTimeAdded = Date()
    }
}
