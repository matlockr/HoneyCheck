//
//  FrameCreator.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/26/21.
//

import SwiftUI

struct FrameCreator: View {
    var body: some View {
        NavigationView{
            Text("Hello")
                
            .navigationBarTitle("Frame Creator", displayMode: .inline)
        }
    }
}

struct FrameCreator_Previews: PreviewProvider {
    static var previews: some View {
        FrameCreator()
    }
}
