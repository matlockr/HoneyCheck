//
//  FrameCreator.swift
//  Honey Aggregator
//
//  Screen for creating and editing frames for each
//  BeeBox

import SwiftUI

struct FrameCreator: View {
    
    @EnvironmentObject var hives:Hives
    
    var hiveIndex: Int
    var beeBoxIndex: Int
    var frameIndex: Int
    
    // Names of templates that are shown on the PickerWheel
    var templates = ["Langstroth Deep", "Langstroth Medium", "Langstroth Shallow"]
    
    // State variables for holding information about textfields
    // and which template is selected
    @State private var templateSelected = 0
    @State private var heightFieldText = ""
    @State private var widthFieldText = ""
    	
    var body: some View {
        VStack{
            // Title of view
            Text("Frame Creator")
                .font(.title)
                .bold()
            
            /*Divider()
            // TODO
            // Template title
            Text("Template Selection")
                .font(.title2)
                

                // Sections group elements together
                // In this case it is used to contain the UI Picker
                Section {
                    Picker(selection: $templateSelected, label: Text("Template")) {
                        ForEach(0 ..< templates.count) {
                            Text(self.templates[$0])
                        }
                    }
                    
                        // Modifier for the UI Picker
                        .pickerStyle(WheelPickerStyle())
                }
            */
            Spacer()
            // Section for holding the manually entered dimensions
            Section{
                
                Divider()
                
                // Hstack for getting the Height entered information
                HStack{
                    Text("Height")
                        .padding()
                        
                    TextField("\(String(hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].height))", text: $heightFieldText)
                        .padding()
                        .keyboardType(.decimalPad)
                }
                
                // Hstack for getting the Width entered information
                HStack{
                    Text("Width")
                        .padding()
                    TextField("\(String(hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].width))", text: $widthFieldText)
                        .padding()
                        .keyboardType(.decimalPad)
                }
            }
            
            
            // Section for the Image getter
            Section{
                
                Divider()
                
                // Title to section
                Text("Frame Picture")
                    .font(.title2)
                
                // Hstack for the frame picture and a button for
                // getting the picture.
                HStack{
                    Spacer()
                    Image("frame" + String(Int.random(in: 1...7)))
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                    Spacer()
                    ZStack{
                        Image(systemName: "circle")
                            .font(.system(size: 70.0))
                        
                        Image(systemName: "camera")
                            .font(.system(size: 40.0))
                    }
                    Spacer()
                }
            }
            
            // Save button for saving the frame
            // Currently just sends user back to last screen.
            Button("Save Frame") {
                if (widthFieldText != "" && heightFieldText != ""){
                    hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].height = Float(heightFieldText) ?? 0.0
                    hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].width = Float(widthFieldText) ?? 0.0
                }
                hives.save()
            }.padding()
            .foregroundColor(.orange)

        }
    }
}

struct FrameCreator_Previews: PreviewProvider {
    static var previews: some View {
        FrameCreator(hiveIndex: 0, beeBoxIndex: 0, frameIndex: 0).environmentObject(Hives())
    }
}
