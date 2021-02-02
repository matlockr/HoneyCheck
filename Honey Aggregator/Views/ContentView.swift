//
//  ContentView.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/20/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView{
            VStack {
                Text("Honey\nAggregator")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.orange)
                    .multilineTextAlignment(.center)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                
                Spacer()
                
                Image("comb")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all)
                
                Spacer()
                
                VStack{
                    NavigationLink(destination: HiveCreator()){
                        Text("New Hive")
                            .font(.title)
                            .bold()
                            .padding(.all)
                        }.buttonStyle(PlainButtonStyle())
                    NavigationLink(destination: HiveListUI()){
                        Text("Hive List")
                            .font(.title)
                            .bold()
                        }.buttonStyle(PlainButtonStyle())
                }
                .navigationBarTitle("", displayMode: .inline)
                .foregroundColor(.orange)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
