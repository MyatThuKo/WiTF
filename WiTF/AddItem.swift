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
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var unit = ""
    
    let listInto =  ["Fridge", "Shopping Cart"]
    @State private var selectedList = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item ", text: $name)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Unit", text: $unit)
                    
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
                        guard !self.name.isEmpty else {
                            self.alertMessage = "Please input the name."
                            self.showAlert.toggle()
                            return
                        }
                        
                        guard !self.amount.isEmpty else {
                            self.alertMessage = "Please input the amount."
                            self.showAlert.toggle()
                            return
                        }
                        
                        if self.selectedList == 0 {
                            let newGrocery = Grocery(context: self.moc)
                            newGrocery.name = self.name
                            newGrocery.amount = Double(self.amount) ?? 0
                            newGrocery.hasExpiration = self.hasExpiration
                            newGrocery.expirationDate = self.expirationDate
                            newGrocery.unit = self.unit
                            
                            try? self.moc.save()
                        } else {
                            let item = ShoppingCart(context: self.moc)
                            item.name = self.name
                            item.amount = Double(self.amount) ?? 0
                            item.expirationDate = self.expirationDate
                            item.hasExpiration = self.hasExpiration
                            item.unit = self.unit
                            
                            try? self.moc.save()
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationBarTitle("Add new item", displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(self.alertMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct AddItem_Previews: PreviewProvider {
    static var previews: some View {
        AddItem()
    }
}
