//
//  NoteTakingSwiftDataApp.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 21/09/2024.
//

import SwiftUI
import SwiftData

@main
struct NoteTakingSwiftDataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
            Person.self,
            Category.self,
            NoteOneToMany.self,
            CategoryOneToMany.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false /* For caching purposes, isStoredInMemoryOnly is useful when you want to avoid writing data to disk to reduce I/O operations or improve performance, especially for frequently accessed or temporary data. */)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            NoteListOneToManyView()
            NotesListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
