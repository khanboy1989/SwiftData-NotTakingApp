//
//  AddItemModalView.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 16/11/2024.
//

import SwiftUI

struct AddItemModalView: View {
    @Binding var newItem: String
    @Binding var selectedCategory: CategoryType
    var onSave: () -> Void // Closure to handle save action
    var onCancel: () -> Void // Closure to cancel action
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter new item", text: $newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(CategoryType.allCases) { category in
                        Text(category.rawValue.capitalized)
                            .tag(category)
                    }
                }
                .pickerStyle(.wheel)
                .padding()
                Spacer()
            }.navigationTitle("Add New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        newItem = ""
                        onCancel()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }.disabled(newItem.isEmpty)
                }
            }
        }
    }
}
