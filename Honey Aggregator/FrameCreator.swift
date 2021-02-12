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
    
    // State variables for image handeling
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    	
    var body: some View {
        VStack{
            // Title of view
            Text("Frame Creator")
                .font(.title)
                .bold()
    
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
                    if image != nil{
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image("comb")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                    }
                    Spacer()
                    ZStack{
                        Image(systemName: "circle")
                            .font(.system(size: 70.0))
                        
                        Image(systemName: "camera")
                            .font(.system(size: 40.0))
                    }
                    .onTapGesture {
                        self.showingImagePicker = true
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
                
                if (inputImage != nil){
                    if let data = inputImage?.jpegData(compressionQuality: 0.5){
                        hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].pictureData = data
                    }
                }
                hives.save()
            }.padding()
            .foregroundColor(.orange)

        }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .onAppear{convertImageFromData()}
    }
    
    func convertImageFromData(){
        if let picData =  hives.hiveList[hiveIndex].beeBoxes[beeBoxIndex].frames[frameIndex].pictureData {
            image = Image(uiImage: UIImage(data: picData)!)
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
    }
}

struct FrameCreator_Previews: PreviewProvider {
    static var previews: some View {
        FrameCreator(hiveIndex: 0, beeBoxIndex: 0, frameIndex: 0).environmentObject(Hives())
    }
}
