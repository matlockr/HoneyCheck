//
//  FrameListRow.swift
//  Honey Aggregator
//
//  Created by Robert Matlock on 2/5/21.
//

import SwiftUI

struct FrameListRow: View {
    
    // Create a Frame object
    var frame: Frame
    @State private var image: Image?
    //used in this file to call singleton level functions
    @EnvironmentObject var hives:Hives
    //used to store the unit type name
    @State private var unitName = ""
    var body: some View {
        //This sets unitName for the weight of the honey in each frame
        //The area value must be 0
        HStack{}.onAppear(perform: {
            unitName = hives.setUnitReadout(unit: UserDefaults.standard.integer(forKey: "unitTypeGlobal"), area: 3)
        })
        // Hstack takes existing frane information and formats it
        // into a single UI element for a list
        HStack{
            if image != nil{
                image?
                    .resizable()
                    .frame(width: 75, height: 75, alignment: .center)
            } else {
                Image("comb")
                    .resizable()
                    .frame(width: 75, height: 75, alignment: .center)
            }
            Text("Honey: \(frame.honeyAmount, specifier: "%.2f") \(unitName)")
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }.onAppear{convertImageFromData()}
    }
    
    func convertImageFromData(){
        if let picData = frame.getPictureData(){
            image = Image(uiImage: UIImage(data: picData)!)
        }
    }
}

struct FrameListRow_Previews: PreviewProvider {
    static var previews: some View {
        FrameListRow(frame: Hives().hiveList[0].beeBoxes[0].frames[0])
    }
}
