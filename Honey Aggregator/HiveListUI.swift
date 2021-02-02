//
//  HiveListUI.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/24/21.
//

import SwiftUI

struct HiveListUI: View {
    var body: some View {
        
            VStack{	
                Text("Hive List")
                    .font(.title)
                    .bold()
                    .padding()
                Divider()
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
