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
    
    @State private var image: Image?
    
    var body: some View {
        
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
            Text("Honey Amount: " + String(box.honeyTotal))
            Spacer()
        }.onAppear{convertImageFromData()}
    }
    
    func convertImageFromData(){
        if let picData = box.getPictureData(){
            image = Image(uiImage: UIImage(data: picData)!)
        }
    }

}

struct BoxListRow_Previews: PreviewProvider {
    static var previews: some View {
        // For preview, show the first box on the first hive in the list
        BoxListRow(box: Hives().hiveList[0].beeBoxes[0])
    }
}
