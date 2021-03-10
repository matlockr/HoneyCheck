//
//  BeeBoxCreator.swift
//  Honey Aggregator
//
//  View for viewing and editing boxes within hives
//

import SwiftUI

struct BeeBoxCreator: View {
    
    // Reference to the singleton object that has the
    // list of hives
    @EnvironmentObject var hives:Hives
    
    // Index of where in the hives list the information should
    // be coming from.
    var hiveIndex: Int
    var beeBoxIndex: Int
    
    var body: some View {
            
        VStack{
            // Hstack for the showing and editing the box name
            HStack{
                Text("BeeBox Name:")
                    .padding()
                Spacer()
                
                // Textfield for displaying and editing the name of the box
                TextField("\(hives.getBeeBoxName(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex))",
                          text: $hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].name)
                    .padding(.all)
                  
            }
            
            // Dividers add a line to help seperate elements
            Divider()
            
            Text("Frames")
                .font(.title2)
                            
            // List shows each of the frames in the box
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
                
                // Button that saves the box to the data file
                Button("Save"){
                    hives.save()
                }.foregroundColor(.orange)
                
                Spacer()
                
            }.padding()
        }
    }
}
