//
//  BoxListRow.swift
//  Honey Aggregator
//
//  Used for putting boxes in a list on HiveCreator
//

import SwiftUI

struct BoxListRow: View {
    
    // Create a BeeBox object
    var box: BeeBox
    
    // Used in this file to call singleton level functions
    @EnvironmentObject var hives:Hives
    
    // Used for the image icon
    @State private var image: Image?
    
    // Used to store the unit type name
    @State private var unitName = ""
    
    var body: some View {
    
        // This sets unitName for the weight of the honey in each box
        // The area value cannot become 0 or 1
        HStack{}.onAppear(perform: {
            unitName = hives.setUnitReadout(unit: UserDefaults.standard.integer(forKey: "unitTypeGlobal"), area: -1)
        })
        
        // Hstack takes existing box information and formats it
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
        
            VStack{
                Text("Box Name: \(box.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            
                // This returns the weight in lb or kg based on UserDefaults unitTypeGlobal
                // This returns lb
                if(UserDefaults.standard.integer(forKey: "unitTypeGlobal") == 0){
                    Text("Honey: \(box.honeyTotal, specifier: "%.2f") \(unitName)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // This returns kg
                else{
                    Text("Honey: \(hives.convertUnitValue(value: box.honeyTotal, direc: "lb2kg"), specifier: "%.2f") \(unitName)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Spacer()
        }.onAppear{convertImageFromData()}
    }
    
    // Takes the Data type variable in the Frame object and
    // converts it into a Swift Image type for placing in View
    func convertImageFromData(){
        if let picData = box.getPictureData(){
            image = Image(uiImage: UIImage(data: picData)!)
        }
    }
}
