//
//  ContentView.swift
//  Honey Aggregator
//
//  Main Screen of the app
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var hives:Hives
    
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
                    NavigationLink(destination: HiveCreator(hiveIndex: navLinkHiveIndex).environmentObject(hives), isActive: self.$isActive){
                    }
                    
                    Button("New Hive") {
                        hives.addHive()
                        navLinkHiveIndex = hives.hiveList.count - 1
                        self.isActive = true;
                    }
                    
                    // Navigation Link for sending user to
                    // HiveListUI View apon clicking button
                    NavigationLink(destination: HiveListUI().environmentObject(hives)){
                        Text("Hive List")
                            .font(.none)
                            .padding(.all)
                        }.buttonStyle(PlainButtonStyle())
                }
                
                // Modifiers for NavigationView
                .navigationBarTitle("", displayMode: .inline)
                .foregroundColor(.orange)
                .onAppear(perform: {
                    
                    //Debug Purposes if there is no hives to start
                    /*
                    if (hives.hiveList.isEmpty){
                        hives.hiveList.append(Hive(hiveName: "Example", honeyTotal: 0.0, beeBoxes: [BeeBox(honeyTotal: 0.0, frames: [Frame(height: 0.0, width: 0.0, honeyAmount: 0.0)])]))
                    }*/
                })
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Hives())
            
    }
}
