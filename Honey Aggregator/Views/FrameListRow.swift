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
    
    var body: some View {
        
        // Hstack takes existing frane information and formats it
        // into a single UI element for a list
        HStack{
            Image("comb")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Spacer()
        }
    }
}

struct FrameListRow_Previews: PreviewProvider {
    static var previews: some View {
        FrameListRow(frame: hives[0].beeBoxes[0].frames[0])
    }
}
