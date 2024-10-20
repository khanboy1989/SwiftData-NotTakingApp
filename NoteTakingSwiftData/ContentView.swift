//
//  ContentView.swift
//  NoteTakingSwiftData
//
//  Created by Serhan Khan on 21/09/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(FetchDescriptor(
        predicate: #Predicate {(person: Person) in person.isLiked == true },
        sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]),
           animation: .snappy) private var favourites: [Person]
    
    @Query(FetchDescriptor(
        predicate: #Predicate {(person: Person) in  person.isLiked == false },
        sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]),
           animation: .snappy) private var notFavourites: [Person]
    
    var body: some View {
        NavigationStack {
            List {
                DisclosureGroup("Favourites") {
                    ForEach(favourites) { person in
                        HStack {
                            Text(person.name)
                            Spacer()
                            Button {
                                person.isLiked.toggle()
                            } label: {
                                Image(systemName: "suit.heart.fill")
                                    .tint(.red)
                            }
                        }.swipeActions {
                            
                        }
                    }
                }
                DisclosureGroup("Not Favourites") {
                    ForEach(notFavourites) { person in
                        HStack {
                            Text(person.name)
                            Spacer()
                            Button {
                                person.isLiked.toggle()
                                try? context.save()
                            } label: {
                                Image(systemName: "suit.heart.fill")
                                    .tint(.gray)
                            }
                        }
                        .swipeActions {
                            Button {
                                context.delete(person)
                                try? context.save()
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .tint(.red)
                        }
                    }
                }
            }.navigationTitle("Swift Data")
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Item") {
                            let person = Person(name: "User \(UUID().uuidString.prefix(10))", isLiked: true)
                            context.insert(person)
                            
                            do {
                                try context.save()
                            }catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                })
        }
    }
}

