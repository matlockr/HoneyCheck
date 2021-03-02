//
//  BeeBoxCreator.swift
//  Honey Aggregator
//
//  Created by Robert Matlock on 2/5/21.
//

import SwiftUI

struct BeeBoxCreator: View {
    
    @EnvironmentObject var hives:Hives
    
    var hiveIndex: Int
    var beeBoxIndex: Int
    
    var body: some View {
            VStack{
                
                // Hstack for the showing and getting hive name
                HStack{
                    Text("BeeBox Name:")
                        .padding()
                    Spacer()
                    
                    TextField("\(hives.getBeeBoxName(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex))",
                              text: $hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].name)
                        .padding(.all)
                      
                }
                
                // Dividers add a line to help seperate elements
                Divider()
                
                Text("Frames")
                    .font(.title2)
                                
                // List shows each of the boxes in the hive
                List{
                    
                    ForEach(hives.getBeeBoxFrames(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex)) { frame in
                        NavigationLink(destination: FrameCreator(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: hives.getBeeBoxFrames(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex).firstIndex(of: frame)!).environmentObject(hives)){
                            FrameListRow(frame: frame)
                        }
                        
                    }.onDelete(perform: { indexSet in
                        hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames.remove(atOffsets: indexSet)
                        hives.setBeeBoxHoney(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex)
                        hives.save()
                    })
                }
                
                Divider()
                
                // Hstack for buttons at bottom of screen
                HStack{
                    
                    Spacer()
                    
                    // Button to add a new frame to the box
                    Button("Add Frame"){
                        hives.addFrame(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex)
                        hives.save()
                    }.foregroundColor(.orange)
                    
                    Spacer()
                    
                    // Button that saves the hive to the model data
                    // Currently just saves a empty hive with the name provided above
                    Button("Save"){
                        hives.save()
                    }.foregroundColor(.orange)
                    
                    Spacer()
                    
                }.padding()
            }
            .navigationBarTitle("BeeBox Creator")
    }
}

struct BeeBoxCreator_Previews: PreviewProvider {
    static var previews: some View {
        BeeBoxCreator(hiveIndex: 0, beeBoxIndex: 0).environmentObject(Hives())
    }
}

