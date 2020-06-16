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
    @State private var amount = 0
    @State private var hasExpiration = false
    @State private var expirationDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item ", text: $name)
                    
                    Stepper("Amount: \(amount)", value: $amount, in: 0...20)
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
                        let newGrocery = Grocery(context: self.moc)
                        newGrocery.name = self.name
                        newGrocery.amount = Int16(self.amount)
                        newGrocery.hasExpiration = self.hasExpiration
                        newGrocery.expirationDate = self.expirationDate
                        
                        try? self.moc.save()
                        
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
