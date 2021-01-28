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
                List{
                    //Example Hive entry
                    HStack{
                        Image("comb")
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding(.all)
                            .clipShape(Circle())
                        Spacer()
                        Text("My Hive!")
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                            .scaledToFill()
                        Spacer()
                    }
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
