//
//  ResetHives.swift
//  Honey Aggregator
//
//  Created by Nico Morales on 5/5/21.
//

import SwiftUI

struct ResetHives: View {
    @EnvironmentObject var hives:Hives
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20, content: {
            
            Text("Confirm Reset?").fontWeight(.semibold)
            Button(action: {
                hives.reset()
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Reset")
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Cancel")
            }
        })
        
    }
}

struct ResetHives_Previews: PreviewProvider {
    static var previews: some View {
        ResetHives()
    }
}
