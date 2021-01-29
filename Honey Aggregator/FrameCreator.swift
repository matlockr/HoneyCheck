//
//  FrameCreator.swift
//  Honey Aggregator
//
//  Created by user190078 on 1/26/21.
//

import SwiftUI

struct FrameCreator: View {
    var templates = ["Langstroth Deep", "Langstroth Medium", "Langstroth Shallow"]

    @State private var templateSelected = 0
    @State private var heightFieldText = ""
    @State private var widthFieldText = ""
    
    //For Debugger purposes
    @State private var saveFrame = false
    
    @Environment(\.presentationMode) var presentation
    	
    var body: some View {
        VStack{
            Text("Frame Creator")
                .font(.title)
                .bold()
                .padding()
            Divider()
            Text("Template Selection")	
                .font(.title2)
                Section {
                    Picker(selection: $templateSelected, label: Text("Template")) {
                        ForEach(0 ..< templates.count) {
                            Text(self.templates[$0])

                        }
                    }
                        .pickerStyle(WheelPickerStyle())
                }
            Section{
                Divider()
                Text("OR Manual Entry")
                    .font(.title2)
                HStack{
                    Text("Height")
                        .padding()
                    TextField("",  text: $heightFieldText)
                        .padding()
                }
                HStack{
                    Text("Width")
                        .padding()
                    TextField("",  text: $widthFieldText)
                        .padding()
                }
            }
            Spacer()
            Section{
                Divider()
                Text("Frame Picture")
                    .padding()
                    .font(.title2)
                HStack{
                    Image("comb")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .padding()
                    ZStack{
                        Image(systemName: "circle")
                            .font(.system(size: 100.0))
                        Image(systemName: "camera")
                            .font(.system(size: 56.0))
                            .padding()
                    }
                }
            }
            Button("Save Frame") {
                self.presentation.wrappedValue.dismiss()
            }

        }
    }
}

struct FrameCreator_Previews: PreviewProvider {
    static var previews: some View {
        FrameCreator()
    }
}
