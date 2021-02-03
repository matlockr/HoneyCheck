//
//  ContentView.swift
//  Honey Aggregator
//
//  Main Screen of the app
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        // NavigationView is the base to the navigation framework
        // for navigating between views
        NavigationView{
            VStack {
                
                // Main title of app
                Text("Honey\nAggregator")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.orange)
                    .multilineTextAlignment(.center)
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                // Spacers spread UI elements apart
                Spacer()
                
                // Default image for logo of app
                Image("comb")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all)
                
                Spacer()
                
                // Second Vstack to hold the main menu buttons
                VStack{
                    
                    // Navigation Link for sending user to
                    // HiveCreator View apon clicking button
                    NavigationLink(destination: HiveCreator()){
                        Text("New Hive")
                            .font(.title)
                            .bold()
                            .padding(.all)
                        }.buttonStyle(PlainButtonStyle())
                    
                    // Navigation Link for sending user to
                    // HiveListUI View apon clicking button
                    NavigationLink(destination: HiveListUI()){
                        Text("Hive List")
                            .font(.title)
                            .bold()
                        }.buttonStyle(PlainButtonStyle())
                }
                
                // Modifiers for NavigationView
                .navigationBarTitle("", displayMode: .inline)
                .foregroundColor(.orange)
                
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
