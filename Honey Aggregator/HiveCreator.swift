//
//  HiveCreator.swift
//  Honey Aggregator
//
//  Screen for editing a hive and adding bee boxes
//

import SwiftUI

struct HiveCreator: View {
    //shares singleton
    @EnvironmentObject var hives:Hives
    
    var hiveIndex: Int
    
    // Enviorment variable for handeling navigation
    @Environment(\.presentationMode) var presentation
        
    @State private var showingAlert = false
    //contains the unit type name
    @State private var unitName = ""
    
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
                //This is where the units of measurement explanation is placed
                HStack{
                    Text("Measurement System:")
                        .onAppear(perform: {
                            //this sets the value of unitName to explain what units are being shown
                            unitName = hives.unitSys(unit: UserDefaults.standard.integer(forKey: "unitTypeGlobal"))
                        })
                        .padding(.horizontal)
                    Text("\(unitName)")
                    
                }
                
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
            
            .navigationBarTitle("Hive Creator")
    }
}

struct HiveCreator_Previews: PreviewProvider {
    static var previews: some View {
        HiveCreator(hiveIndex: 0).environmentObject(Hives())
    }
}
