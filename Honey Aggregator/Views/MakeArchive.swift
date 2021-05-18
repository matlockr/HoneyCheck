//
//  Make Archive.swift
//  Honey Aggregator
//
//  Created by Nico Morales on 5/5/21.
//

import SwiftUI

struct MakeArchive: View {
    @EnvironmentObject var hives:Hives
    @Environment(\.presentationMode) var presentationMode
    @State var seasonName: String
    @State var warning: String
    var body: some View {
        VStack( content: {
            Text("Start New Season")
            
            Spacer()
            
            Text("Do you want to archive the season?  You can't edit it once it is archived.")
                .fontWeight(.semibold)
                .padding()
                .font(.system(size: 20))
            Spacer()
            TextField("Name this season", text: $seasonName)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 255/255, green: 248/255, blue: 235/255)))
            
            Button(action: {
                let check = hives.archive(file: "\(seasonName).json")
                if check == "Season was successfully archived!"{
                    self.presentationMode.wrappedValue.dismiss()
                }
                else{
                    warning = check
                }
            }){
                Text("Archive")
                    .foregroundColor(Color.orange)
                    .padding(10)
                    .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                    .cornerRadius(10)
                    .font(.system(size: 20, weight: .heavy))
            }
            .disabled(seasonName.isEmpty)
            
            if(warning.isEmpty){
                Text("\(warning)").hidden()
            }
            else{
                Text("\(warning)").padding()
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Cancel")
                    .foregroundColor(Color.orange)
                    .padding(10)
                    .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                    .cornerRadius(10)
                    .font(.system(size: 20, weight: .heavy))
            }.padding(.bottom)
        })
        
    }
}
/*
struct Make_Archive_Previews: PreviewProvider {
    static var previews: some View {
        Make_Archive()
    }
}*/
