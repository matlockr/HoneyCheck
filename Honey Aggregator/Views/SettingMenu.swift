//
//  SettingMenu.swift
//  Honey Aggregator
//
//  Setting menu view
//

import SwiftUI

struct SettingMenu: View {
        
    // Holds the value selected in the picker
    @State private var selectedUnitType = UserDefaults.standard.integer(forKey: "unitTypeGlobal")
    
    var body: some View {
        VStack{
            
            // Title for view
            Text("Unit Type")
                .font(.title)
                .padding()
            
            // This is where the unit type is selected
            Picker(selection: $selectedUnitType, label: Text("Measurement System"), content: {
                    Text("Imperial: in/oz/lb").tag(0)
                    Text("Metric: mm/g/KG").tag(1)
                    Text("Metric: cm/g/KG").tag(2)
                    Text("Metric: dm/g/KG").tag(3)
                    Text("Metric: m/g/KG").tag(4)
                }
            )
            // This sets the UserDefaults value for the unit type
            .onChange(of: self.selectedUnitType, perform: { value in
                UserDefaults.standard.set(self.selectedUnitType, forKey: "unitTypeGlobal")
            })
            
            Spacer()
        }
        .navigationBarTitle("Settings")
    }
}
