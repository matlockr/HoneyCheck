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
    
    var body: some View {
        
        // Hstack takes existing box information and formats it
        // into a single UI element for a list
        HStack{
            Image("frame" + String(Int.random(in: 1...7)))
                .resizable()
                .frame(width: 75, height: 75, alignment: .center)
            Spacer()
        }
    }
}

struct BoxListRow_Previews: PreviewProvider {
    static var previews: some View {
        // For preview, show the first box on the first hive in the list
        BoxListRow(box: Hives().hiveList[0].beeBoxes[0])
    }
}
