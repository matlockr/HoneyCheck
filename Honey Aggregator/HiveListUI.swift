//
//  HiveListUI.swift
//  Honey Aggregator
//
//  Screen for showing list of hives
//

import SwiftUI

struct HiveListUI: View {
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    var body: some View {
            VStack{
                
                Divider()
                
                // List for showing each of the hives saved in the
                // JSON file
                List{
                    ForEach(hives.hiveList) { hive in
                        NavigationLink(destination: HiveCreator(hiveIndex: hives.hiveList.firstIndex(of: hive)!).environmentObject(hives)){
                            HiveListRow(hive: hive)
                        }
                    }.onDelete(perform: { indexSet in
                        hives.hiveList.remove(atOffsets: indexSet)
                        hives.save()
                    })
                }
                
                Spacer()
                Divider()
            }
            .navigationBarTitle("Hives")
    }
}
