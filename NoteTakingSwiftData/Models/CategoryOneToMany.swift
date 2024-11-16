//
//  CategoryOneToMany.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 16/11/2024.
//

import SwiftData
import Foundation

@Model class CategoryOneToMany: Identifiable {
    @Attribute(.unique) var id: UUID
    var categoryTypeRawValue: String
    @Relationship var belongsTo: Note?
    
    init(categoryType: CategoryType, belongsTo: Note? = nil) {
        self.id = UUID()
        self.belongsTo = belongsTo
        self.categoryTypeRawValue = categoryType.rawValue
    }
}
