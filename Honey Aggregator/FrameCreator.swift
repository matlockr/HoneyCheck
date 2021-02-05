//
//  FrameCreator.swift
//  Honey Aggregator
//
//  Screen for creating and editing frames for each
//  BeeBox

import SwiftUI

struct FrameCreator: View {
    
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
    
    // Enviormental variable for programmatically navigating
    // backwards.
    @Environment(\.presentationMode) var presentation
    	
    var body: some View {
        VStack{
            // Title of view
            Text("Frame Creator")
                .font(.title)
                .bold()
            
            Divider()
            
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
            
            // Section for holding the manually entered dimensions
            Section{
                
                Divider()
                
                // Hstack for getting the Height entered information
                HStack{
                    Text("Height")
                        .padding()
                    TextField("",  text: $heightFieldText)
                        .padding()
                }
                
                // Hstack for getting the Width entered information
                HStack{
                    Text("Width")
                        .padding()
                    TextField("",  text: $widthFieldText)
                        .padding()
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
                    Image("comb")
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                    ZStack{
                        Image(systemName: "circle")
                            .font(.system(size: 70.0))
                        Image(systemName: "camera")
                            .font(.system(size: 40.0))
                    }
                }
            }
            
            // Save button for saving the frame
            // Currently just sends user back to last screen.
            Button("Save Frame") {
                self.presentation.wrappedValue.dismiss()
            }

        }
    }
}

struct FrameCreator_Previews: PreviewProvider {
    static var previews: some View {
        FrameCreator(hiveIndex: -1, beeBoxIndex: -1, frameIndex: -1)
    }
}
