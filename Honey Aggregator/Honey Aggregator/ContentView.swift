//
//  ContentView.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/20/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("Honey \nAggregator")
                .fontWeight(.black)
                .foregroundColor(Color.orange)
                .multilineTextAlignment(.center)
                .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                .lineLimit(2)
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            Spacer()
            
            Image("comb")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all)
            
            Spacer()
            
            VStack{
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("New Hive")
                        .font(.title)
                        .bold()
                        
                }.padding()
                
                
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Hive List")
                        .font(.title)
                        .bold()
                        
                }.padding()
                
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
