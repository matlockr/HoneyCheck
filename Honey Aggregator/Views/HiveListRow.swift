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
    
    var body: some View {
        
        // Hstack takes existing hive information and formats it
        // into a single UI element for a list
        HStack{
            Image("frame" + String(Int.random(in: 1...7)))
                .resizable()
                .frame(width: 75, height: 75, alignment: .center)
            Text(hive.hiveName)
            Spacer()
        }
    }
}

struct HiveListRow_Previews: PreviewProvider {
    static var previews: some View {
        // For preview, show the first hive in the list
        HiveListRow(hive: Hives().hiveList[0])
    }
}
