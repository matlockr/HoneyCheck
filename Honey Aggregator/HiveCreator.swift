//
//  HiveCreator.swift
//  Honey Aggregator
//
//  Screen for editing a hive and adding bee boxes
//

import SwiftUI

struct HiveCreator: View {
    
    var hiveIndex: Int
    
    // State variable for holding hive name
    @State private var tempHiveName = ""
    
    // Enviorment variable for handeling navigation
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
            VStack{
                // Title for view
                Text("Hive Creator")
                    .font(.title)
                    .bold()
                
                // Dividers add a line to help seperate elements
                Divider()
                
                // Hstack for the showing and getting hive name
                HStack{
                    Text("Hive Name:")
                        .padding()
                    Spacer()
                    
                    TextField("Hive Name", text: $tempHiveName)
                        .padding(.all)
                }
                
                Spacer()
                
                // List shows each of the boxes in the hive
                List(hives[hiveIndex].beeBoxes) { box in
                    NavigationLink(destination: BeeBoxCreator(hiveIndex: hiveIndex, beeBoxIndex: box.id)){
                    
                        BoxListRow(box: box)
                    }
                }
            
                
                Divider()
                
                // Hstack for buttons at bottom of screen
                HStack{
                    
                    // Button that creates a box for the hive
                    Button("Add BeeBox"){
                        let newBeeBox = BeeBox(id: hives[hiveIndex].beeBoxes.count, honeyTotal: 0.0, frames: [])
                        hives[hiveIndex].beeBoxes.append(newBeeBox)
                    }.foregroundColor(.orange)
                    
                    // Button that saves the hive to the model data
                    // Currently just saves a empty hive with the name provided above
                    Button("Save"){
                        hives[hiveIndex].hiveName = tempHiveName
                        save(hiveIndex: hiveIndex)
                    }.foregroundColor(.orange)
                }.padding()
            }

    }
}

struct HiveCreator_Previews: PreviewProvider {
    static var previews: some View {
        HiveCreator(hiveIndex: 0)
    }
}
