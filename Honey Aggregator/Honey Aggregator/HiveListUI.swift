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
            HStack{
                Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("<")
                }.padding()
                Spacer()
                Text("Hive List")
                    .fontWeight(.black)
                    .foregroundColor(Color.orange)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .lineLimit(2)
                    .padding(.all)
                Spacer()
            }
            Divider()
            
            List{
                //Example Hive entry
                HStack{
                    Circle()
                        .frame(width: 40.0)
                    Spacer()
                    Text("My Hive!")
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .scaledToFill()
                    Spacer()

                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Text(">")
                    }
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
