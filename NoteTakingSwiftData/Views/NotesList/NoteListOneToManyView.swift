//
//  NoteListOneToManyView.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 15/11/2024.
//

import SwiftUI
import SwiftData

struct NoteListOneToManyView: View {
    @State private var isPresentingModal: Bool = false
    @State private var newItem: String = ""
    @State private var selectedCategories: [CategoryType] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Item") {
                        isPresentingModal.toggle()
                    }
                }
            }.sheet(isPresented: $isPresentingModal) {
                AddItemWithMultipleCategoriesView(selectedCategories: $selectedCategories, newItem: $newItem, onSave: {
                    
                }, onCancel: {
                    
                })
            }
        }
    }
}
