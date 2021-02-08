//
//  ContentView.swift
//  Honey Aggregator
//
//  Main Screen of the app
//

import SwiftUI

struct ContentView: View {
    
    @State private var isActive: Bool = false;
    @State private var navLinkHiveIndex = -1;
    
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
                    NavigationLink(destination: HiveCreator(hiveIndex: navLinkHiveIndex), isActive: self.$isActive){
                    }
                    
                    Button("New Hive") {
                        let newHive = Hive(hiveName: "None", honeyTotal: 0.0, beeBoxes: [])
                        hives.append(newHive)
                        navLinkHiveIndex = hives.count - 1
                        self.isActive = true;
                    }
                    
                    // Navigation Link for sending user to
                    // HiveListUI View apon clicking button
                    NavigationLink(destination: HiveListUI()){
                        Text("Hive List")
                            .font(.none)
                            .padding(.all)
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
