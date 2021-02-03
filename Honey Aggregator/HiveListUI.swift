//
//  HiveListUI.swift
//  Honey Aggregator
//
//  Screen for showing list of saved hives
//

import SwiftUI

struct HiveListUI: View {
    var body: some View {
            VStack{
                
                // Title for view
                Text("Hive List")
                    .font(.title)
                    .bold()
                    .padding()
                
                Divider()
                
                // List for showing each of the hives saved in the
                // JSON file
                List(hives) { hive in
                    HiveListRow(hive: hive)
                }
                
                Spacer()
                
                Divider()
            }
    }
}

struct HiveListUI_Previews: PreviewProvider {
    static var previews: some View {
        HiveListUI()
    }
}
