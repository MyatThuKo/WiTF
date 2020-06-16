//
//  ContentView.swift
//  WiTF
//
//  Created by Myat Thu Ko on 6/15/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct TextView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .font(.title)
            .padding()
            .frame(width: 300, height: 100)
            .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .green]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    NavigationLink(destination: ListView()) {
                        TextView(text: "Items in the Fridge")
                    }
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: ShoppingListView()) {
                        HStack {
                            Image(systemName: "cart")
                                .font(.title)
                            Text("Shopping cart")
                                .fontWeight(.semibold)
                                .font(.title)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 100)
                        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .orange]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle("What's in the Fridge?")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
