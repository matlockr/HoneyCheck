//
//  BeeBoxCreator.swift
//  Honey Aggregator
//
//  Created by Robert Matlock on 2/5/21.
//

import SwiftUI

struct BeeBoxCreator: View {
    
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
                // Currently just gives a default box for now
                if (beeBoxIndex != -1){
                    List(hives[0].beeBoxes[0].frames) { frame in
                        NavigationLink(destination: FrameCreator(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frame.id)){
                            FrameListRow(frame: frame)
                        }
                    }
                }
                
                Divider()
                
                // Hstack for buttons at bottom of screen
                HStack{
                    
                    // Navigation link that sends user to FrameCreator View
                    // at this time.
                    NavigationLink(destination: FrameCreator(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: -1)){
                        Text("Add Frame")
                            .foregroundColor(.orange)
                    }.buttonStyle(PlainButtonStyle())
                    
                    // Button that saves the hive to the model data
                    // Currently just saves a empty hive with the name provided above
                    Button("Save"){
                        let newHive = Hive(id: 3, hiveName: "NULL", honeyTotal: 0.0, beeBoxes: [])
                        save(filename:"hiveData.json", newHive: newHive)
                    }.foregroundColor(.orange)
                }.padding()
            }
        
    }
}

struct BeeBoxCreator_Previews: PreviewProvider {
    static var previews: some View {
        BeeBoxCreator(hiveIndex: -1, beeBoxIndex: -1)
    }
}

