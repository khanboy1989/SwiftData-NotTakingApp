//
//  NotesListView.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 21/09/2024.
//

import SwiftUI
import SwiftData

struct NotesListView: View {
    @State private var isPresentingModal: Bool = false
    @State private var newItem: String = ""
    @State private var selectedCategory: CategoryType = .work
    
    @Query(FetchDescriptor(predicate: #Predicate {( note: Note ) in note.isDone == false }, sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]), animation: .snappy) private var todoNotes: [Note]
    
    @Query(FetchDescriptor(predicate: #Predicate {( note: Note ) in note.isDone == true }, sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]), animation: .snappy) private var doneNotes: [Note]
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Section for To-Do Notes
                    Section(header: Text("To Do")) {
                        ForEach(todoNotes, id: \.id) { note in
                            NoteRowView(note: note, context: context)
                        }
                    }
                    
                    // Section for Done Notes
                    Section(header: Text("Done")) {
                        ForEach(doneNotes, id: \.id) { note in
                            NoteRowView(note: note, context: context)
                        }
                    }
                }
            }.navigationTitle("Tasks List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        isPresentingModal.toggle()
                    }
                }
            }
            .sheet(isPresented: $isPresentingModal) {
                AddItemModalView(newItem: $newItem, selectedCategory: $selectedCategory, onSave: {
                    // Action to add a new item to the list
                    if !newItem.isEmpty {
                        let note = Note(content: newItem, isDone: false)
                        let category = Category(categoryType: selectedCategory, belongsTo: note)
                        context.insert(category)
                        do {
                            try context.save()
                        } catch {
                            print("Error saving: \(error.localizedDescription)")
                        }
                    }
                    newItem = ""
                    isPresentingModal.toggle()
                    selectedCategory = .work
                }, onCancel: {
                    isPresentingModal.toggle()
                })
            }
        }
    }
}


