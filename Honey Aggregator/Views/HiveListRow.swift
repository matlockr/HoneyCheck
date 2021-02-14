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
    @State private var image: Image?
    
    var body: some View {
        
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
                Text("Honey: \(hive.honeyTotal, specifier: "%.2f") lbs")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }.onAppear{convertImageFromData()}
    }
    
    func convertImageFromData(){
        if let picData = hive.getPictureData(){
            image = Image(uiImage: UIImage(data: picData)!)
        }
    }

}

struct HiveListRow_Previews: PreviewProvider {
    static var previews: some View {
        // For preview, show the first hive in the list
        HiveListRow(hive: Hives().hiveList[0])
    }
}
