//
//  NoteRowView.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 15/11/2024.
//

//
//  NoteRowView.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 15/11/2024.
//

import SwiftUI
import SwiftData

struct NoteRowView: View {
    @Bindable var note: Note
    var isEditMode: Bool
    var onSelectionChanged: (Note) -> Void
    var delete: (Note) -> Void
    var onDone: (Note) -> Void
    
    var body: some View {
        HStack {
            if isEditMode {
                Image(systemName: note.isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(note.isSelected ? .blue : .gray)
                    .onTapGesture {
                        note.isSelected.toggle()
                        onSelectionChanged(note)
                    }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.content)
                    .font(.headline)
                    .strikethrough(note.isDone, color: .gray)
                    .foregroundColor(note.isDone ? .gray : .primary)
                
                Text(note.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let category = note.category {
                    Text(category.categoryTypeRawValue)
                        .font(.subheadline)
                        .padding(6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
            
            if !isEditMode {
                Button(action: {
                    toggleDoneStatus()
                }) {
                    Image(systemName: note.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(note.isDone ? .green : .blue)
                        
                }.swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        delete(note)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Helper Method
    
    private func toggleDoneStatus() {
        note.isDone.toggle()
        onDone(note)
    }
}
