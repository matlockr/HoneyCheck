//
//  HiveCreator.swift
//  Honey Aggregator
//
//  Screen for editing a hive and adding bee boxes
//

import SwiftUI

struct HiveCreator: View {
    
    @EnvironmentObject var hives:Hives
    
    var hiveIndex: Int
    
    // Enviorment variable for handeling navigation
    @Environment(\.presentationMode) var presentation
    
    @State private var tempHiveName = "None"
    
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
                    
                    TextField("\(hives.getHiveName(hiveIndex: hiveIndex))",
                              text: $hives.hiveList[hiveIndex].hiveName)
                        .padding(.all)
                        
                }
                
                Spacer()
                
                // List shows each of the boxes in the hive
                /*
                List(hives.hiveList[hiveIndex].beeBoxes) { box in
                    NavigationLink(destination: BeeBoxCreator(hiveIndex: hiveIndex, beeBoxIndex: hives.getHiveBeeBoxes(hiveIndex: hiveIndex).firstIndex(of: box)!).environmentObject(hives)){
                    
                        BoxListRow(box: box)
                    }
                }
                */
                List{
                    ForEach(hives.hiveList[hiveIndex].beeBoxes) { box in
                        NavigationLink(destination: BeeBoxCreator(hiveIndex: hiveIndex, beeBoxIndex: hives.getHiveBeeBoxes(hiveIndex: hiveIndex).firstIndex(of: box)!).environmentObject(hives)){
                        
                            BoxListRow(box: box)
                        }
                    }.onDelete(perform: { indexSet in
                        hives.hiveList[hiveIndex].beeBoxes.remove(atOffsets: indexSet)
                        hives.save()
                    })
                }
            
                
                Divider()
                
                // Hstack for buttons at bottom of screen
                HStack{
                    
                    // Button that creates a box for the hive
                    Button("Add BeeBox"){
                        hives.addBeeBox(hiveIndex: hiveIndex)
                        hives.save()
                    }.foregroundColor(.orange)
                    
                    // Button that saves the hive to the model data
                    // Currently just saves a empty hive with the name provided above
                    Button("Save"){
                        hives.setHiveName(hiveIndex: hiveIndex, name: tempHiveName)
                        hives.save()
                    }.foregroundColor(.orange)
                }.padding()
            }

    }
}

struct HiveCreator_Previews: PreviewProvider {
    static var previews: some View {
        HiveCreator(hiveIndex: 0).environmentObject(Hives())
    }
}
