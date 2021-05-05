//
//  SettingsMenu.swift
//  Honey_Agg
//
//  Created by Robert Matlock on 3/20/21.
//

import SwiftUI

struct SettingsMenu: View {
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    @State private var showingActionSheet = false
    // This is just used for being able to dissmiss the view in code
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        VStack{
            //Unit selection
            Text("Unit Type")
                .padding()
                .font(.title2)
            
            HStack{
                
                Button(action: {
                    hives.isMetric = false
                    hives.readOut = hives.getReadOut()
                    // Dismiss the view and return to the ContentView view
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Imperial")
                }
                
            
                Button(action: {
                    hives.isMetric = true
                    hives.readOut = hives.getReadOut()
                    // Dismiss the view and return to the ContentView view
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Metric")
                }
            }
            
            Spacer()
            
            Divider()
            
            //Start new season button
            Button(action: {
                print("Start New Season Clicked")
            }){
                Text("Start New Season")
            }
            
            // View old season list
            // TODO: Actually make this functional
            Spacer()
            
            Spacer()
            
            Text("View Old Season")
                .font(.title2)
            
            List{
                Text("2020")
                Text("2018")
                Text("2019")
            }
            Button(action: {
                self.showingActionSheet = true
                // Dismiss the view and return to the ContentView view
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Clear Current Hives")
            }
        }
        .navigationBarItems(leading: Text("Honey Aggregator")).actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Clear Hive Data"), buttons: [
                .default(Text("Confirm Reset?")) { hives.reset() },
                 .cancel()
                    ]
                )
            }
    }
    
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu().environmentObject(Hives())
    }
}
