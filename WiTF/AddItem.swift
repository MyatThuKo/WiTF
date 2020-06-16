//
//  AddItem.swift
//  WiTF
//
//  Created by Myat Thu Ko on 6/15/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct AddItem: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var hasExpiration = false
    @State private var expirationDate = Date()
    
    let listInto =  ["Fridge", "Shopping Cart"]
    @State private var selectedList = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item ", text: $name)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Add Into: ", selection: $selectedList) {
                        ForEach(0..<listInto.count, id: \.self) {
                            Text("\(self.listInto[$0])")
                        }
                    }
                }
                
                Section {
                    Toggle(isOn: $hasExpiration.animation()) {
                        Text("Has Expiration Date?")
                    }
                    
                    if hasExpiration == true {
                        DatePicker(selection: $expirationDate, displayedComponents: .date) {
                            Text("Expiration Date")
                        }
                    }
                }
                
                Section {
                    Button("Save") {
                        if self.selectedList == 0 {
                            let newGrocery = Grocery(context: self.moc)
                            newGrocery.name = self.name
                            newGrocery.amount = Double(self.amount) ?? 0
                            newGrocery.hasExpiration = self.hasExpiration
                            newGrocery.expirationDate = self.expirationDate
                            
                            try? self.moc.save()
                        } else {
                            let item = ShoppingCart(context: self.moc)
                            item.name = self.name
                            item.amount = Double(self.amount) ?? 0
                            item.expirationDate = self.expirationDate
                            item.hasExpiration = self.hasExpiration
                            
                            try? self.moc.save()
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add new item", displayMode: .inline)
        }
    }
}

struct AddItem_Previews: PreviewProvider {
    static var previews: some View {
        AddItem()
    }
}
