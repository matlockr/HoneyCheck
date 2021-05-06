//
//  SettingsMenu.swift
//  Honey_Agg
//
//  Created by Robert Matlock on 3/20/21.
//  Special thanks to Paul Hudson
//   https://www.hackingwithswift.com/quick-start/swiftui/enabling-and-disabling-elements-in-forms
//  Special thanks to Andrew Jackson
//  https://medium.com/@codechimp_org/implementing-multiple-action-sheets-from-toolbar-buttons-with-swiftui-ce3bce2b97cb
import SwiftUI

struct SettingsMenu: View {
    //The enum is used to create multiple action sheets
    enum Sheets: Identifiable {
            case reset, archiveMake

            var id: Int {
                self.hashValue
            }
        }
    //activeSheet is used to add child sheets
    @State var activeSheet: Sheets?
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
                self.activeSheet = .archiveMake
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
                self.activeSheet = .reset
                //self.showingActionSheet = true
                // Dismiss the view and return to the ContentView view
                //presentationMode.wrappedValue.dismiss()
            }){
                Text("Clear Current Hives")
            }
        }.sheet(item: $activeSheet, onDismiss: { activeSheet = nil }) { item in
            switch item {
            case .reset:
                ResetHives()
            case .archiveMake:
                MakeArchive(seasonName: "", warning: "")
            }
            
        }
        /*.navigationBarItems(leading: Text("Honey Aggregator")).actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Clear Hive Data"), buttons: [
                .default(Text("Confirm Reset?")) { hives.reset() },
                 .cancel()
                    ]
                )
            }*/
    }
    
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu().environmentObject(Hives())
    }
}
