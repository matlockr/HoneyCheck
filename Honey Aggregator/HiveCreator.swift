//
//  HiveCreator.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/26/21.
//

import SwiftUI

struct HiveCreator: View {
    @State private var tempHiveName = ""
    
    private var columns: [GridItem] = [
            GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 16),
    ]
    
    var body: some View {
            VStack{
                Text("Hive Creator")
                    .font(.title)
                    .bold()
                    .padding()
                Divider()
                HStack{
                    Text("Hive Name:")
                        .padding()
                    Spacer()
                    TextField("Enter Name", text: $tempHiveName)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                }
                Divider()
                Spacer()
                ScrollView {
                            LazyVGrid(
                                columns: columns,
                                alignment: .center,
                                spacing: 16,
                                pinnedViews: [.sectionHeaders, .sectionFooters]
                            ) {
                                Section(header: Text("Frames").font(.title)) {
                                    ForEach(0..<10, id: \.self) { index in
                                        Image("comb")
                                            .resizable()
                                            .frame(width: 100, height: 100, alignment: .center)
                                    }
                                }
                            }
                        }
                Divider()
                HStack{
                    NavigationLink(destination: FrameCreator()){
                        Text("Add Frame")
                            .font(.title)
                            .bold()
                            .padding(.all)
                        }.buttonStyle(PlainButtonStyle())
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Text("Save")
                            .font(.title)
                            .bold()
                            .padding()
                    }.buttonStyle(PlainButtonStyle())
                }
            }

    }
}

struct HiveCreator_Previews: PreviewProvider {
    static var previews: some View {
        HiveCreator()
    }
}
