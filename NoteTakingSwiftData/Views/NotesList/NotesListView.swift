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
    @Query(FetchDescriptor(predicate: #Predicate {( note: Note ) in note.isDone == false }, sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]), animation: .snappy) private var todoNotes: [Note] = []
    
    @Query(FetchDescriptor(predicate: #Predicate {( note: Note ) in note.isDone == true }, sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]), animation: .snappy) private var doneNotes: [Note] = []
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    DisclosureGroup("To Do") {
                        ForEach(todoNotes, id:\.id) { note in
                            HStack(alignment: .center) {
                                Text(note.content)
                                Spacer()
                                Text("\(note.dateAdded.formatDate())")
                            }
                            
                            .swipeActions {
                                Button { // Delete
                                    context.delete(note)
                                    try? context.save()
                                } label: {
                                    Image(systemName: "trash.fill")
                                }
                                .tint(.red)
                                
                                
                                Button { // Mark as done
                                    note.isDone.toggle()
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .tint(.green)
                                
                            }
                        }
                    }
                    
                    DisclosureGroup("Done") {
                        ForEach(doneNotes, id:\.id) { note in
                            HStack(alignment: .center) {
                                Text(note.content)
                                Spacer()
                                Text("\(note.dateAdded.formatDate())")
                            }
                            .swipeActions {
                                Button {
                                    context.delete(note)
                                    try? context.save()
                                } label: {
                                    Image(systemName: "trash.fill")
                                }
                                .tint(.red)
                                Button {
                                    note.isDone.toggle()
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .tint(.gray)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        isPresentingModal = true
                    }
                }
            }
            .sheet(isPresented: $isPresentingModal) {
                AddItemModalView(newItem: $newItem) {
                    // Action to add new item to the list
                    if !newItem.isEmpty {
                        context.insert(Note(content: newItem, isDone: false))
                        newItem = ""
                        do {
                            try context.save()
                        } catch {
                            print("Error on saving =\(error.localizedDescription)" )
                        }
                    }
                    isPresentingModal = false
                }
            }
        }
    }
    
    func addItem(note: Note) {
        context.insert(note)
        do {
            try context.save()
        } catch {
            print("Error on saving =\(error.localizedDescription)")
        }
    }
    
    func deletItem(note: Note) {
        context.delete(note)
        try? context.save()
    }
}

struct AddItemModalView: View {
    @Binding var newItem: String
    var onSave: () -> Void // Closure to handle save action
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter new item", text: $newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onSave() // Calls the closure to add the item and dismiss
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }
                }
            }
        }
    }
}
