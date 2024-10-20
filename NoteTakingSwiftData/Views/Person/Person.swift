//
//  Person.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 18/10/2024.
//

import SwiftData
import Foundation

@Model
class Person {
    var name: String
    var isLiked: Bool
    var dateAdded: Date
    
    init(name: String, isLiked: Bool = false, dateAdded: Date = .init()) {
        self.name = name
        self.isLiked = isLiked
        self.dateAdded = dateAdded
    }
}
