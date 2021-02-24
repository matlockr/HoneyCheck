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
    //holds the value selected in the picker
    @State private var selectedUnitType = UserDefaults.standard.integer(forKey: "unitTypeGlobal")
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
                //this is where the unit type is selected
                Picker(selection: $selectedUnitType, label: Text("Measurement System"), content: {
                        Text("Imperial: in/oz/lb").tag(0)
                        Text("Metric: mm/g/KG").tag(1)
                        Text("Metric: cm/g/KG").tag(2)
                        Text("Metric: dm/g/KG").tag(3)
                        Text("Metric: m/g/KG").tag(4)
                    }
                )
                //This sets the UserDefaults value for the unit type
                .onChange(of: self.selectedUnitType, perform: { value in
                    UserDefaults.standard.set(self.selectedUnitType, forKey: "unitTypeGlobal")
                })
                //this controls how much of the picker is in view
                .frame(height: 60)
                //this makes the above change appear on screen
                .clipped()
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
