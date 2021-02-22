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
        
    @State private var showingAlert = false
    //contains the unit type for hive
    @State private var selectedUnitType = 0
    
    
    var body: some View {
        
            VStack{
                
                // Hstack for the showing and getting hive name
                HStack{
                    Text("Hive Name:")
                        .padding()
                    Spacer()
                    
                    TextField("\(hives.getHiveName(hiveIndex: hiveIndex))",
                              text: $hives.hiveList[hiveIndex].hiveName)
                        .padding(.all)
                        
                }
                Form{
                    Picker(selection: $selectedUnitType, label: Text("Measurement System"), content: {
                            Text("Imperial: in/oz/lb").tag(0)
                            Text("Metric: mm/g/KG").tag(1)
                            Text("Metric: cm/g/KG").tag(2)
                            Text("Metric: dm/g/KG").tag(3)
                            Text("Metric: m/g/KG").tag(4)
                        }
                    )
                }
                .frame(height: 70)
                .clipped()
                
                Divider()
                
                Text("BeeBoxes")
                    .font(.title2)
                
                
                // List shows each of the boxes in the hive
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
            
            .navigationBarTitle("Hive Creator")
    }
}

struct HiveCreator_Previews: PreviewProvider {
    static var previews: some View {
        HiveCreator(hiveIndex: 0).environmentObject(Hives())
    }
}
