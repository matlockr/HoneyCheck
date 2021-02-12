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
                
                // Title for view
                Text("BeeBox Creator")
                    .font(.title)
                    .bold()
                
                // Dividers add a line to help seperate elements
                Divider()
                
                
                Spacer()
                
                // List shows each of the boxes in the hive
                List(hives.getBeeBoxFrames(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex)) { frame in
                    NavigationLink(destination: FrameCreator(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: hives.getBeeBoxFrames(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex).firstIndex(of: frame)!).environmentObject(hives)){
                        FrameListRow(frame: frame)
                    }
                }
                
                Divider()
                
                // Hstack for buttons at bottom of screen
                HStack{
                    
                    // Button to add a new frame to the box
                    Button("Add Frame"){
                        hives.addFrame(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex)
                        hives.save()
                    }.foregroundColor(.orange)
                    
                    // Button that saves the hive to the model data
                    // Currently just saves a empty hive with the name provided above
                    Button("Save"){
                        hives.save()
                    }.foregroundColor(.orange)
                }.padding()
            }
        
    }
}

struct BeeBoxCreator_Previews: PreviewProvider {
    static var previews: some View {
        BeeBoxCreator(hiveIndex: 0, beeBoxIndex: 0).environmentObject(Hives())
    }
}

