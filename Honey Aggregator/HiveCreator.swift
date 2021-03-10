//
//  HiveCreator.swift
//  Honey Aggregator
//
//  Screen for editing a hive and adding bee boxes
//

import SwiftUI

struct HiveCreator: View {
    
    // Shared singleton of main hives list
    @EnvironmentObject var hives:Hives
    
    // Index of where in the hives list the information should
    // be coming from.
    var hiveIndex: Int
    
    // Enviorment variable for handeling navigation
    @Environment(\.presentationMode) var presentation
            
    // Contains the unit type name
    @State private var unitName = ""
    
    var body: some View {
    
        VStack{
            // Hstack for the showing and editing the hive name
            HStack{
                Text("Hive Name:")
                    .padding()
                Spacer()
                
                // Textfield for changing the hive's name
                TextField("\(hives.getHiveName(hiveIndex: hiveIndex))",
                          text: $hives.hiveList[hiveIndex].hiveName)
                    .padding(.all)
                    
            }
            
            Divider()
            
            Text("BeeBoxes")
                .font(.title2)
        
            // List shows each of the boxes in the hive
            List{
                ForEach(hives.hiveList[hiveIndex].beeBoxes) { box in
                    NavigationLink(destination: BeeBoxCreator(hiveIndex: hiveIndex, beeBoxIndex: hives.getHiveBeeBoxes(hiveIndex: hiveIndex).firstIndex(of: box)!).environmentObject(hives)){
                        
                        // Displays the subview within this current view
                        BoxListRow(box: box)
                    }
                }.onDelete(perform: { indexSet in
                    hives.hiveList[hiveIndex].beeBoxes.remove(atOffsets: indexSet)
                    hives.setHiveHoneyTotal(hiveIndex: hiveIndex)
                    hives.save()
                })
            }
        
            Divider()
            
            // Hstack for buttons at bottom of screen
            HStack{
                Spacer()
                
                // Button that creates a box for the hive
                Button("Add BeeBox"){
                    hives.addBeeBox(hiveIndex: hiveIndex)
                    hives.save()
                }.foregroundColor(.orange)
                
                Spacer()
                
                // Button that saves the hive to the model data
                Button("Save"){
                    hives.save()
                }.foregroundColor(.orange)
                
                Spacer()
            }.padding()
        }
    }
}
