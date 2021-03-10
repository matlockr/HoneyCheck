//
//  HiveListRow.swift
//  Honey Aggregator
//
//  Used for HiveListUI list of hives
//

import SwiftUI

struct HiveListRow: View {
    
    // Create a hive object
    var hive: Hive
    
    // Used in this file to call singleton level functions
    @EnvironmentObject var hives:Hives
    
    // Used to hold the image for the row icon
    @State private var image: Image?
    
    // Used to store the unit type for each hive
    @State private var unitName = ""
    
    var body: some View {
    
        // This sets unitName for the weight of the honey in each hive
        // The area value cannot become 0 or 1
        HStack{}.onAppear(perform: {
            unitName = hives.setUnitReadout(unit: UserDefaults.standard.integer(forKey: "unitTypeGlobal"), area: -1)
        })
        
        // Hstack takes existing hive information and formats it
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
                Text("Name: " + hive.hiveName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Honey: \(hive.honeyTotal, specifier: "%.2f") \(unitName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }.onAppear{convertImageFromData()}
    }
    
    // Takes the Data type variable in the Frame object and
    // converts it into a Swift Image type for placing in View
    func convertImageFromData(){
        if let picData = hive.getPictureData(){
            image = Image(uiImage: UIImage(data: picData)!)
        }
    }

}
