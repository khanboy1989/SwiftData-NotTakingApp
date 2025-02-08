import SwiftUI
import SwiftData

struct NoteListViewWithReusableItemView: View {
    
    // Swift Data model context for queries and other operations
    @Environment(\.modelContext) private var context
    
    @Query(FetchDescriptor(predicate: #Predicate{(note: Note) in note.isDone == false }, sortBy: [SortDescriptor(\.dateAdded)]), animation: .snappy) private var todoNotes: [Note]
    
    @Query(FetchDescriptor(predicate: #Predicate{( note: Note ) in note.isDone == true}, sortBy: [SortDescriptor(\.dateAdded)]), animation: .snappy) private var doneNotes: [Note]
    
    @State private var selectedNotes: Set<Note> = []
    @State private var isPresentingModal: Bool = false
    @State private var newItem: String = ""
    @State private var selectedCategory: CategoryType = .work
    @State private var showAlert: Bool = false
    @State private var alertType: AlertType?
    @State private var isEditMode: Bool = false
    
    private enum AlertType {
        case error
        case success
        var message: String {
            switch self {
            case .success: return "Operation completed successfully."
            case .error: return "Something went wrong. Please try again."
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("TO DO")) {
                        ForEach(todoNotes, id: \.id) { note in
                            ListItemView(title: note.content,
                                         subtitle: note.formattedDate,
                                         category: note.category?.categoryTypeRawValue,
                                         isDone: note.isDone,
                                         isSelected: Binding(get: {
                                selectedNotes.contains(note)
                            }, set: { newValue in
                                if newValue {
                                    selectedNotes.insert(note)
                                } else {
                                    selectedNotes.remove(note)
                                }
                            }),
                            isEditMode: isEditMode,
                            onDelete: {
                                handleDeleteNote(note)
                            }, onDone: {
                                handleOnDone(note)
                            })
                            .listRowBackground(Color.clear)
                            .contentShape(Rectangle())
                        }
                    }
                    
                    Section(header: Text("Done")) {
                        ForEach(doneNotes, id: \.id) { note in
                            ListItemView(title: note.content, subtitle: note.formattedDate,
                                         category: note.category?.categoryTypeRawValue,
                                         isDone: note.isDone,
                                         isSelected:
                                            Binding(get: {
                                selectedNotes.contains(note)
                            }, set: { newValue in
                                if newValue {
                                    selectedNotes.insert(note)
                                } else {
                                    selectedNotes.remove(note)
                                }
                            }),
                            isEditMode: isEditMode,
                            onDelete: {
                                handleDeleteNote(note)
                            }, onDone: {
                                handleOnDone(note)
                            })
                            .listRowBackground(Color.clear)
                            .contentShape(Rectangle())
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
                    onSave()
                }, onCancel: {
                    isPresentingModal.toggle()
                })
            }
            .alert("Message", isPresented: $showAlert) {
                Button("OK", role: .cancel) { showAlert.toggle() }
            } message: {
                Text(alertType?.message ?? "An unexpected error occurred.")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleDeleteNote(_ note: Note) {
        context.delete(note)
        do {
            try context.save()
            showAlert(.success)
        } catch {
            showAlert(.error)
        }
    }
    
    private func handleOnDone(_ note: Note) {
        note.isDone.toggle()
        do {
            try context.save()
        } catch {
            showAlert(.error)
        }
    }
    
    private func onSave() {
        if !newItem.isEmpty {
            let note = Note(content: newItem, isDone: false)
            let category = Category(categoryType: selectedCategory, belongsTo: note)
            context.insert(category)
            do {
                try context.save()
                showAlert(.success)
            } catch {
                showAlert(.error)
            }
            newItem = ""
            isPresentingModal.toggle()
            selectedCategory = .work
        }
    }
    
    private func deleteSelectedNotes() {
        for note in selectedNotes {
            context.delete(note)
        }
        selectedNotes.removeAll()
        do {
            try context.save()
            self.showAlert(.success)
        } catch {
            showAlert(.error)
        }
    }
    
    private func markAsDoneSelectedNotes() {
        for note in selectedNotes {
            note.isDone.toggle()
        }
        do {
            try context.save()
            self.showAlert(.success)
        } catch {
            self.showAlert(.error)
        }
    }
    
    private func showAlert(_ type: AlertType) {
        alertType = type
        showAlert = true
    }
}
