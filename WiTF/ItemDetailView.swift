//
//  ItemDetailView.swift
//  WiTF
//
//  Created by Myat Thu Ko on 6/15/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI
import CoreData

struct ItemDetailView: View {
    let groceryItem: Grocery
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDeleteAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var plusAngle = 0.0
    @State private var minusAngle = 0.0
    
    @State private var amount = ""
    
    var formattedDate: String {
        if let date = self.groceryItem.expirationDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        } else {
            return "N/A"
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.pink, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                TextView(text: "Item: \(self.groceryItem.name ?? "Unknown Item")")
                
                Spacer()
                
                if groceryItem.hasExpiration == true {
                    Text("Expires on: \(self.formattedDate)")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .padding()
                        .frame(width: 300, height: 100)
                        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                    
                    Spacer()
                }
                
                VStack {
                    TextField("Amount Changed", text: $amount)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                    
                    HStack {
                        Text("Amount: \(self.groceryItem.amount, specifier:"%g") \(self.groceryItem.unit ?? "N/A")")
                        Button(action: {
                            self.plusAngle += 180
                            self.groceryItem.amount += Double(self.amount) ?? 0.0
                            self.amount = ""
                            try? self.moc.save()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 50))
                                .clipShape(Circle())
                                .animation(Animation.linear.repeatForever(autoreverses: false))
                                .foregroundColor(.red)
                        }
                        .rotation3DEffect(.degrees(plusAngle), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeIn)
                        
                        Button(action: {
                            self.minusAngle += 180
                            if self.groceryItem.amount > 0 {
                                self.groceryItem.amount -= Double(self.amount) ?? 0.0
                                self.amount = ""
                                try? self.moc.save()
                            } else {
                                self.showDeleteAlert = true
                                self.alertTitle = "Finished Item?"
                                self.alertMessage = "Item will be removed!"
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 50))
                                .clipShape(Circle())
                                .animation(Animation.linear.repeatForever(autoreverses: false))
                                .foregroundColor(.red)
                        }
                        .rotation3DEffect(.degrees(minusAngle), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeIn)
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarTitle("\(groceryItem.name ?? "Unknown Item")", displayMode: .inline)
        .navigationBarItems(trailing: HStack{
            // Delete Button
            Button(action: {
                self.alertTitle = "Delete Item"
                self.alertMessage = "Are you sure?"
                self.showDeleteAlert.toggle()
            }) {
                HStack {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
        })
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), primaryButton: .destructive(Text("Delete")) {
                    self.deleteItem()
                    }, secondaryButton: .cancel())
        }
    }
    
    func deleteItem() {
        moc.delete(groceryItem)
        
        try? moc.save()
        
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct ItemDetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let grocery = Grocery(context: moc)
        grocery.name = "Grocery Name"
        grocery.amount = 0
        
        return NavigationView {
            ItemDetailView(groceryItem: grocery)
        }
    }
}
