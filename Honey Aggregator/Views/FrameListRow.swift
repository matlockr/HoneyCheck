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
    
    // Used for the image icon on the frame
    @State private var image: Image?
    
    // Used in this file to call singleton level functions
    @EnvironmentObject var hives:Hives
    
    // Used to store the unit type name
    @State private var unitName = ""
    
    var body: some View {
    
        // This sets unitName for the weight of the honey in each frame
        // The area value must be 0
        HStack{}.onAppear(perform: {
            unitName = hives.setUnitReadout(unit: UserDefaults.standard.integer(forKey: "unitTypeGlobal"), area: 0)
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
        
            // This converts the weights displayed based on the UserDefaults unitTypeGlobal
            // This returns oz
            if(UserDefaults.standard.integer(forKey: "userTypeGlobal") == 0){
                Text("Honey: \(hives.convertUnitValue(value: frame.honeyAmount, direc: "lb2oz"), specifier: "%.2f") \(unitName)")
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            // This returns grams
            else{
                Text("Honey: \(hives.convertUnitValue(value: frame.honeyAmount, direc: "lb2g"), specifier: "%.2f") \(unitName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }.onAppear{convertImageFromData()}
    }
    
    // Takes the Data type variable in the Frame object and
    // converts it into a Swift Image type for placing in View
    func convertImageFromData(){
        if let picData = frame.getPictureData(){
            image = Image(uiImage: UIImage(data: picData)!)
        }
    }
}
