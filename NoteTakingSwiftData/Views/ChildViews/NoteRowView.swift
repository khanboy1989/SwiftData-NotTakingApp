//
//  NoteRowView.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 15/11/2024.
//

import SwiftData
import SwiftUI

struct NoteRowView: View {
    let note: Note
    let context: ModelContext
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(note.content)
                if let category = note.category?.categoryTypeRawValue {
                    Text("Category: \(category)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Text(note.dateAdded.formatDate())
                .font(.caption)
                .foregroundColor(.secondary)
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
                Image(systemName: note.isDone ? "xmark" : "checkmark")
            }
            .tint(note.isDone ? .gray : .green)
        }
    }
}
