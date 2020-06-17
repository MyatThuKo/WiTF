//
//  ShoppingListView.swift
//  WiTF
//
//  Created by Myat Thu Ko on 6/16/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct ShoppingListView: View {
    @FetchRequest(entity: ShoppingCart.entity(), sortDescriptors: []) var shoppingCart: FetchedResults<ShoppingCart>
    @State private var showSheets = false
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        Form {
            Section {
                ForEach(shoppingCart, id: \.self) { item in
                    VStack(alignment: .leading) {
                        Text("\(item.name ?? "Unknown Item")")
                        
                        Text("Amount: \(item.amount, specifier: "%g") \(item.unit ?? "N/A")")
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteItem)
            }
            
            Section(header: Text("Add item here")) {
                Button(action: {
                    self.showSheets.toggle()
                }) {
                    Text("Add")
                }
            }
        }
        .navigationBarTitle("Shopping Cart", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
        .sheet(isPresented: $showSheets) {
            AddItem().environment(\.managedObjectContext, self.moc)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let item = shoppingCart[offset]
            
            // delete it from the context
            moc.delete(item)
        }
        
        // save the context
        try? moc.save()
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
