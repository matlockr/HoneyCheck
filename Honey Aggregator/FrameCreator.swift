//
//  FrameCreator.swift
//  Honey Aggregator
//
//  Screen for creating and editing frames for each
//  BeeBox
//  Additional thanks to @karthickselvaraj from Medium.com for sourceType information https://medium.com/better-programming/how-to-pick-an-image-from-camera-or-photo-library-in-swiftui-a596a0a2ece

import SwiftUI

struct FrameCreator: View {
    //@ObservedObject var input = Numerical()

    @EnvironmentObject var hives:Hives
    
    var hiveIndex: Int
    var beeBoxIndex: Int
    var frameIndex: Int
    
    // State variables for holding information about textfields
    @State private var heightFieldText = ""
    @State private var widthFieldText = ""
    
    // State variables for image handeling
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    //Bool used to trigger the camera in the ImagePicker
    @State private var shouldPresentCamera = false
    //Bool used to trigger user choice for image selection
    @State private var shouldPresentActionSheet = false
    //Bool used to trigger drop down menu
    
    
    var body: some View {
        VStack{
            
        }
        VStack{
            
            Spacer()
            
            // Section for holding the manually entered dimensions
            Section{
                
                // Title to section
                Text("Dimensions")
                    .font(.title)
                
                // Hstack for getting the Height entered information
                HStack{
                    Text("Height")
                        .padding()
                        
                    TextField("\(String(hives.getFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex)))", text: $heightFieldText)
                        .padding()
                        .keyboardType(.decimalPad)
                        
                    
                    Text("inches")
                        .padding()
                }
                
                // Hstack for getting the Width entered information
                HStack{
                    Text("Width ")
                        .padding()
                    
                    TextField("\(String(hives.getFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex)))", text: $widthFieldText)
                        .padding()
                        .keyboardType(.decimalPad)
                    
                    Text("inches")
                        .padding()
                }
            }
            
            Spacer()
            
            // Section for the Image getter
            Section{
                
                
                // Title to section
                Text("Picture")
                    .font(.title)
                
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
                        //dis line is cancir
                        //recommend removing commented out line
                        //self.showingImagePicker = true
                        //will allow Action Sheet to be toggled on
                        self.shouldPresentActionSheet = true
                    }
                    Spacer()
                }
            }
            Spacer()
            
            // Save button for saving the frame
            // Currently just sends user back to last screen.
            Button("Save Frame") {
                if (widthFieldText != "" && heightFieldText != ""){
                    hives.setFrameHeight(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, height: Float(heightFieldText) ?? 0.0)
                    hives.setFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, width: Float(widthFieldText) ?? 0.0)
                }
                
                if (inputImage != nil){
                    if let data = inputImage?.jpegData(compressionQuality: 0.1){
                        hives.setPictureData(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, data: data)
                    }
                }
                
                // Get the frame square inches
                let frameSquareInches = hives.getFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex) * hives.getFrameWidth(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex)
                
                hives.setHoneyTotal(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex, honeyTotal: Float.random(in: (0.1)...1) * frameSquareInches * 0.0149)
                hives.setBeeBoxHoney(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex)
                hives.save()
            }.padding()
            .foregroundColor(.orange)

        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            //This call to the constructor brings up the ImagePicker
            //sourceType uses the ? to set up an if else condition for variable shouldPresentCamera: Bool
            ImagePicker(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$inputImage)
        }
        //Call to Action Sheet constructor isPresented is a Bool value which calls Binding<Bool> shouldPresentActionSheet
        //Action Sheet lists buttons in top down order, i.e. Camera is at top, cancel is at bottom
        .actionSheet(isPresented: $shouldPresentActionSheet) {
            //This creates the action sheet
            () -> ActionSheet in
            //This gives the Action Sheet a title
            //This gives the action sheet a message for the user to read
            //The syntax "action:" is used to define any behavior that pressing a button will perform in the code
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                //This will toggle the ImagePicker on
                self.showingImagePicker = true
                //This will cause ImagePicker to toggle the camera on
                self.shouldPresentCamera = true
            }),
            //This creates a "Photo Library" button
            ActionSheet.Button.default(Text("Photo Library"), action: {
                //This toggles the ImagePicker on
                self.showingImagePicker = true
                //This prevents the camera from toggling on
                self.shouldPresentCamera = false
            }),
            //This creates a "Cancel" button
            ActionSheet.Button.cancel()])
        }
        .onAppear{convertImageFromData()}
        .navigationBarTitle("Frame Creator")
        
    }
    
    func convertImageFromData(){
        if let picData =  hives.getPictureData(hiveIndex: hiveIndex, beeBoxIndex: beeBoxIndex, frameIndex: frameIndex){
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

