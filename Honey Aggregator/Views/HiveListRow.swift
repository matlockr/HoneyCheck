//
//  HiveListRow.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/31/21.
//

import SwiftUI

struct HiveListRow: View {
    var hive: Hive
    
    var body: some View {
        HStack{
            Image("comb")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Text(hive.hiveName)
            Spacer()
        }
    }
}

struct HiveListRow_Previews: PreviewProvider {
    static var previews: some View {
        HiveListRow(hive: hives[0])
    }
}
