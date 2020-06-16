//
//  ListView.swift
//  WiTF
//
//  Created by Myat Thu Ko on 6/15/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Grocery.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Grocery.name, ascending: true)]) var grocery: FetchedResults<Grocery>
    
    @State private var showAddView = false
    
    // To display Date in a TextView 
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        Form {
            Section {
                ForEach(grocery, id: \.self) { item in
                    NavigationLink(destination: ItemDetailView(groceryItem: item)) {
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Unknown Item")
                                .font(.headline)
                            
                            HStack {
                                Text("Amount: \(item.amount)")
                                    .foregroundColor(.secondary)
                                if item.hasExpiration == true {
                                    Text("Expires on: \(item.expirationDate!, formatter: Self.taskDateFormat)")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItem)
            }
            
            Section {
                Button(action: {
                    self.showAddView.toggle()
                }) {
                    Text("Add New Item")
                }
            }
        }
        .navigationBarTitle("Items Inside Fridge", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
        .sheet(isPresented: $showAddView) {
            AddItem().environment(\.managedObjectContext, self.moc)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let item = grocery[offset]
            
            // delete it from the context
            moc.delete(item)
        }
        
        // save the context
        try? moc.save()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
