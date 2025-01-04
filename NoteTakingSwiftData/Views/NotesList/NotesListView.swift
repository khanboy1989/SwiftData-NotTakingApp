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
    @State private var isEditMode: Bool = false
    @State private var newItem: String = ""
    @State private var selectedCategory: CategoryType = .work
    @State private var selectedNotes: Set<Note> = []
    
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
                            NoteRowView(note: note, isEditMode: isEditMode, onSelectionChanged: handleSelectionChanged, delete: handleDeletion, onDone: handleDoneStatus)
                                .listRowSeparator(.hidden)
                        }
                    }
                    
                    // Section for Done Notes
                    Section(header: Text("Done")) {
                        ForEach(doneNotes, id: \.id) { note in
                            NoteRowView(note: note, isEditMode: isEditMode, onSelectionChanged: handleSelectionChanged, delete: handleDeletion, onDone: handleDoneStatus)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                
                if isEditMode {
                    HStack {
                        Button(role: .destructive) {
                            deleteSelectedNotes()
                        } label: {
                            Text("Delete Selected (\(selectedNotes.count))")
                                .padding(.leading, 8)
                        }
                        .disabled(selectedNotes.isEmpty)
                        if selectedNotes.first(where: { $0.isDone == false }) != nil {
                            Button {
                                markAsDoneSelectedNotes()
                            } label: {
                                Text("Mark As Done (\(selectedNotes.count))")
                                    .foregroundStyle(.blue)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        isPresentingModal.toggle()
                    }
                }
                
                ToolbarItem {
                    Button(isEditMode ? "Done" : "Edit") {
                        isEditMode.toggle()
                        if !isEditMode {
                            selectedNotes.removeAll()
                            todoNotes.forEach { $0.isSelected = false }
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresentingModal) {
                AddItemModalView(newItem: $newItem, selectedCategory: $selectedCategory, onSave: {
                    self.onSave()
                }, onCancel: {
                    self.onCancel()
                })
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleSelectionChanged(note: Note) {
        withAnimation {
            if note.isSelected {
                selectedNotes.insert(note)
            } else {
                selectedNotes.remove(note)
            }
        }
    }
    
    private func handleDeletion(note: Note) {
        context.delete(note)
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
    
    private func deleteSelectedNotes() {
        for note in selectedNotes {
            context.delete(note)
        }
        selectedNotes.removeAll()
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
    
    private func markAsDoneSelectedNotes() {
        for note in selectedNotes {
            note.isDone.toggle()
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
            
        }
    }
    
    private func handleDoneStatus(note: Note) {
        do {
            try context.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
            
        }
    }
    
    private func onSave() {
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
    }
    
    private func onCancel() {
        isPresentingModal.toggle()
    }
}
