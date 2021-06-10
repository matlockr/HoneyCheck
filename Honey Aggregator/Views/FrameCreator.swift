import SwiftUI

struct FrameCreator: View {
    
    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
    
    // This is just used for being able to dissmiss the view in code
    @Environment(\.presentationMode) var presentationMode
    
    // Setup the starting state for the Finite State Machine
    @State private var state = STATE.SelectHive
    
    // Hold information about the selected hive, box, and template
    @State private var selectedHive: Hive?
    @State private var selectedBox: BeeBox?
    @State private var selectedTemplate: Template?
    
    // This is for changeing the title text of the top navigation var
    // when the state of the view changes
    @State private var titleText: String = "Select Hive"
    
    // Hold the honey amount for the frame so it can be used when
    // creating the frame at the end state
    @State private var tempHoneyAmount: Float = 0.0
    @State private var frameSideAHoneyAmount: Float = 0.0
    @State private var frameSideBHoneyAmount: Float = 0.0
    
    // Turn on/off image processing by drawing
    @State private var showDrawingPictureHandler: Bool = false
                
    var body: some View {
        VStack{
            // Each if statement shows a different subview based on what the current
            // state is
            if state == STATE.SelectHive{
                
                // Show the HiveCreator view
                HiveCreator(state: $state, selectedHive: $selectedHive, titleText: $titleText).environmentObject(hives)
                
            } else if state == STATE.SelectBox{
                
                // Show the BoxCreator view
                BoxCreator(selectedHive: selectedHive!, state: $state, selectedBox: $selectedBox, titleText: $titleText).environmentObject(hives)
                
            } else if state == STATE.SelectFrame{
                
                // Show the FrameSelector view
                FrameSelector(selectedBox: selectedBox!, state: $state, titleText: $titleText).environmentObject(hives)
                
            } else if state == STATE.SelectTemplate{
                
                // Show the TemplateSelector view
                TemplateSelector(state: $state, selectedTemplate: $selectedTemplate, titleText: $titleText).environmentObject(hives)
                
            } else if state == STATE.CustomTemplate{
                
                // Show the CustomTemplateCreator view
                CustomTemplateCreator(state: $state, selectedTemplate: $selectedTemplate, titleText: $titleText).environmentObject(hives)
                
            } else if state == STATE.Picture1Get{
                
                // Go to Drawing view is user selects to use drawing feature
                if hives.isDrawingHandler{
                    PictureHandler(selectedTemplate: selectedTemplate!, titleText: $titleText, state: $state, tempHoneyAmount: $tempHoneyAmount, sideAHoneyAmount: $frameSideAHoneyAmount, sideBHoneyAmount: $frameSideBHoneyAmount)
                } else {
                    AutomatedPictureHandler(selectedTemplate: selectedTemplate!, titleText: $titleText, state: $state, honeyTotal: $tempHoneyAmount, sideAHoneyAmount: $frameSideAHoneyAmount, sideBHoneyAmount: $frameSideBHoneyAmount)
                }
                    
                //Show a current calculation value to monitor changes in the frame calculation. Might remove due to no need to see during state 1, but could be helpful for debugging for now. 
                if hives.isMetric {
                    Text("Current Calculation: \(String(format: "%.2f", tempHoneyAmount / 2.2)) kg")
                        .padding()
                } else {
                    Text("Current Calculation: \(String(format: "%.2f", tempHoneyAmount)) lbs")
                        .padding()
                }
                
            } else if state == STATE.Picture2Get{
                
                // Go to Drawing view is user selects to use drawing feature
                if hives.isDrawingHandler{
                    PictureHandler(selectedTemplate: selectedTemplate!, titleText: $titleText, state: $state, tempHoneyAmount: $tempHoneyAmount, sideAHoneyAmount: $frameSideAHoneyAmount, sideBHoneyAmount: $frameSideBHoneyAmount)
                } else {
                    AutomatedPictureHandler(selectedTemplate: selectedTemplate!, titleText: $titleText, state: $state, honeyTotal: $tempHoneyAmount, sideAHoneyAmount: $frameSideAHoneyAmount, sideBHoneyAmount: $frameSideBHoneyAmount)
                }
                
                //Show a current calculation value to monitor changes in the frame calculation.
                if hives.isMetric {
                    Text("Current Calculation: \(String(format: "%.2f", tempHoneyAmount / 2.2)) kg")
                        .padding()
                } else {
                    Text("Current Calculation: \(String(format: "%.2f", tempHoneyAmount)) lbs")
                        .padding()
                }
                
            } else if state == STATE.Finalize{
                
                // Display all the information of the new frame that will be
                // created.
                HStack{
                    Text("Hive Name:")
                        .padding(.horizontal)
                        .font(.system(size: 20, weight: .heavy))
                    Spacer()
                    Text("\(selectedHive!.hiveName)")
                        .font(.system(size: 20, weight: .heavy))
                        .padding(.horizontal)
                }.background(Color(red: 255/255, green: 194/255, blue: 82/255))
                HStack{
                    Text("Box Number:")
                        .padding(.horizontal)
                        .font(.system(size: 20, weight: .heavy))
                    Spacer()
                    Text("\(selectedBox!.idx + 1)")
                        .font(.system(size: 20, weight: .heavy))
                        .padding(.horizontal)
                }.background(Color(red: 255/255, green: 218/255, blue: 148/255))
                
                if hives.isMetric{
                    HStack{
                        Text("Frame height:")
                            .padding(.horizontal)
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                        Text("\(String(format: "%.2f", selectedTemplate!.height * 25.4)) mm")
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal)
                    }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                    HStack{
                        Text("Frame width:")
                            .padding(.horizontal)
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                        Text("\(String(format: "%.2f", selectedTemplate!.width * 25.4)) mm")
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal)
                    }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                    HStack{
                        Text("Honey amount:")
                            .padding(.horizontal)
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                        Text("\(String(format: "%.2f", tempHoneyAmount / 2.2)) kg")
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal)
                    }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                } else {
                    HStack{
                        Text("Frame height:")
                            .padding(.horizontal)
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                        Text("\(String(format: "%.2f", selectedTemplate!.height)) in")
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal)
                    }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                    HStack{
                        Text("Frame width:")
                            .padding(.horizontal)
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                        Text("\(String(format: "%.2f", selectedTemplate!.width)) in")
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal)
                    }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                    HStack{
                        Text("Side A Honey:")
                            .padding(.horizontal)
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                        Text("\(String(format: "%.2f", frameSideAHoneyAmount)) lbs")
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal)
                    }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                    HStack{
                        Text("Side B Honey:")
                            .padding(.horizontal)
                            .font(.system(size: 20, weight: .heavy))
                        Spacer()
                        Text("\(String(format: "%.2f", frameSideBHoneyAmount)) lbs")
                            .font(.system(size: 20, weight: .heavy))
                            .padding(.horizontal)
                    }.background(Color(red: 255/255, green: 235/255, blue: 201/255))
                }
                
                // Button to finilize the frame and add it to the hive
                Button(action: {
                    // Create the new frame and add it to the selected box
                    hives.addFrame(boxid: selectedBox!.id, height: selectedTemplate!.height, width: selectedTemplate!.width, honeyTotalSideA: frameSideAHoneyAmount, honeyTotalSideB: frameSideBHoneyAmount)
                    
                    hives.save(file: "")
                    
                    // Dismiss the view and return to the ContentView view
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Done")
                        .foregroundColor(Color.orange)
                        .padding(10)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .heavy))
                }
                .padding()
            }
        }
        .navigationBarTitle(Text(titleText))
        
        // Navigation toolbar changes based on what state the View is in
        .navigationBarItems(leading:
            Button(action: {
                // Dismiss the view and return to the ContentView view
                presentationMode.wrappedValue.dismiss()
            }){
                Text("Home")
                    .foregroundColor(Color.orange)
            }
        )
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Button(action: {
                    switch state {
                    case .SelectHive:
                        // Dismiss the view and return to the ContentView view
                        presentationMode.wrappedValue.dismiss()
                        break
                    case .SelectBox:
                        state = .SelectHive
                        titleText = "Select Hive"
                        break
                    case .SelectFrame:
                        state = .SelectBox
                        titleText = "Select Box"
                        break
                    case .SelectTemplate:
                        state = .SelectFrame
                        titleText = "Frames"
                        break
                    case .CustomTemplate:
                        state = .SelectTemplate
                        titleText = "Select Template"
                        break
                    case .Picture1Get:
                        state = .SelectTemplate
                        titleText = "Custom Template"
                        break
                    case .Picture2Get:
                        state = .Picture1Get
                        tempHoneyAmount = 0.0
                        titleText = "Side A Picture"
                        break
                    case .Finalize:
                        state = .Picture2Get
                        tempHoneyAmount -= frameSideBHoneyAmount
                        titleText = "Side B Picture"
                        break
                    }
                }){
                    Image(systemName: "arrowshape.turn.up.left.fill")
                }
                
                // Plus button for certain states that have certain actions
                if state == STATE.SelectBox || state == STATE.SelectFrame{
                    Button(action: {
                        if state == STATE.SelectBox{
                            
                            //Add a box to the selected hive
                            hives.addBox(hiveid: selectedHive!.id)
                            hives.save(file: "")
                        } else if state == STATE.SelectFrame{
                            
                            //Add a box to the selected hive
                            state = STATE.SelectTemplate
                            titleText = "Select Template"
                        }
                    }){
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
