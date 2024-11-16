//
//  Category.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 13/11/2024.
//

import SwiftData
import Foundation

enum CategoryType: String, CaseIterable, Identifiable {
    case work = "Work"
    case personal = "Personal"
    case idea = "Idea"
    case important = "Important"
    case travelling = "Travelling"
    var id: String { self.rawValue }
}

@Model class Category: Identifiable {
    @Attribute(.unique) var id: UUID
    var categoryTypeRawValue: String    
    @Relationship var belongsTo: Note?

    init(categoryType: CategoryType, belongsTo: Note? = nil) {
        self.id = UUID()
        self.belongsTo = belongsTo
        self.categoryTypeRawValue = categoryType.rawValue
    }
}
