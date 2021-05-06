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
            Spacer()
            Text("Do you want to archive the season?  You can't edit it once it is archived.").fontWeight(.semibold).padding()
            Spacer()
            TextField("Name this season", text: $seasonName).padding()
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
            }.padding(20).disabled(seasonName.isEmpty)
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
            }.padding(20)
        })
        
    }
}
/*
struct Make_Archive_Previews: PreviewProvider {
    static var previews: some View {
        Make_Archive()
    }
}*/
