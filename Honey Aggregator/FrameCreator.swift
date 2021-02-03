//
//  FrameCreator.swift
//  Honey Aggregator
//
//  Screen for creating and editing frames for each
//  BeeBox

import SwiftUI

struct FrameCreator: View {
    
    // Names of templates that are shown on the PickerWheel
    var templates = ["Langstroth Deep", "Langstroth Medium", "Langstroth Shallow"]
    
    // State variables for holding information about textfields
    // and which template is selected
    @State private var templateSelected = 0
    @State private var heightFieldText = ""
    @State private var widthFieldText = ""
    
    // Triggers screen to go back to Hive Creator
    // Will eventually send back to box creator
    @State private var saveFrame = false
    
    // Enviormental variable for programmatically navigating
    // backwards.
    @Environment(\.presentationMode) var presentation
    	
    var body: some View {
        VStack{
            
            // Title of view
            Text("Frame Creator")
                .font(.title)
                .bold()
                .padding()
            
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
                
                // Title for section
                Text("OR Manual Entry")
                    .font(.title2)
                
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
            
            Spacer()
            
            // Section for the Image getter
            Section{
                
                Divider()
                
                // Title to section
                Text("Frame Picture")
                    .padding()
                    .font(.title2)
                
                // Hstack for the frame picture and a button for
                // getting the picture.
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
        FrameCreator()
    }
}
