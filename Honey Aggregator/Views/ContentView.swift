//
//  ContentView.swift
//  Honey Aggregator
//
//  Main Screen of the app
//

import SwiftUI

struct ContentView: View {
    
    // Singleton object that holds hives list
    @EnvironmentObject var hives:Hives
    
    // State variables for current view
    @State private var isNavigationViewActive: Bool = false;
    @State private var navLinkHiveIndex = -1;

    var body: some View {
        
        // NavigationView is the base to the navigation framework
        // for navigating between views
        NavigationView {
            
            VStack {
                
                // Main title of app
                Text("Honey\nAggregator")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.orange)
                    .multilineTextAlignment(.center)
                    .padding(.all)
                
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
                    NavigationLink(destination: HiveCreator(hiveIndex: navLinkHiveIndex).environmentObject(hives), isActive: self.$isNavigationViewActive){
                    }
                    
                    // Button for creating a new hive
                    Button("New Hive") {
                        hives.addHive()
                        navLinkHiveIndex = hives.hiveList.count - 1
                        self.isNavigationViewActive = true;
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
                
                // Toolbar for navigating to the setting menu
                .toolbar{
                    ToolbarItem(){
                        NavigationLink(destination: SettingMenu()){
                            Text("Settings")
                                .font(.none)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
            }
        }
    }
}
