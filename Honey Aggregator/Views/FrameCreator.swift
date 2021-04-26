//
//  FrameCreator.swift
//  Honey_Agg
//
//  The FrameCreator view that allows users to add and remove
//  hives, boxes, and frames.
//

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
                
                // Show the PictureHandler view
                PictureHandler(selectedTemplate: selectedTemplate!, titleText: $titleText, state: $state, tempHoneyAmount: $tempHoneyAmount).environmentObject(hives)
                
                //Show a current calculation value to monitor changes in the frame calculation. Might remove due to no need to see during state 1, but could be helpful for debugging for now. 
                if hives.isMetric {
                    Text("Current Calculation: \(String(format: "%.2f", tempHoneyAmount / 2.2)) kg")
                        .padding()
                } else {
                    Text("Current Calculation: \(String(format: "%.2f", tempHoneyAmount)) lbs")
                        .padding()
                }
                
            } else if state == STATE.Picture2Get{
                
                // Show the PictureHandler view
                PictureHandler(selectedTemplate: selectedTemplate!, titleText: $titleText, state: $state, tempHoneyAmount: $tempHoneyAmount).environmentObject(hives)
                
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
                Text("Hive Name: \(selectedHive!.hiveName)")
                Text("Box Number: \(selectedBox!.idx)")
                if hives.isMetric{
                    Text("Frame height: \(String(format: "%.2f", selectedTemplate!.height * 25.4)) mm")
                    Text("Frame Width: \(String(format: "%.2f", selectedTemplate!.width * 25.4)) mm")
                    Text("Honey Amount: \(String(format: "%.2f", tempHoneyAmount / 2.2)) kg")
                } else {
                    Text("Frame height: \(String(format: "%.2f", selectedTemplate!.height)) in")
                    Text("Frame Width: \(String(format: "%.2f", selectedTemplate!.width)) in")
                    Text("Honey Amount: \(String(format: "%.2f", tempHoneyAmount)) lbs")
                }
                
                Button(action: {
                    // Create the new frame and add it to the selected box
                    hives.addFrame(boxid: selectedBox!.id, height: selectedTemplate!.height, width: selectedTemplate!.width, honeyTotal: tempHoneyAmount)
                    
                    hives.save()
                    
                    // Dismiss the view and return to the ContentView view
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Done")
                }
            }
        }
        // Navigation bar title text
        .navigationBarItems(leading: Text("\(titleText)"))
        // Navigation toolbar changes based on what state the View is in
        .toolbar{
            ToolbarItemGroup(placement: .navigationBarTrailing){
                if state == STATE.SelectBox || state == STATE.SelectFrame{
                    Button(action: {
                        if state == STATE.SelectBox{
                            
                            //Add a box to the selected hive
                            hives.addBox(hiveid: selectedHive!.id)
                            hives.save()
                        } else if state == STATE.SelectFrame{
                            
                            //Add a box to the selected hive
                            state = STATE.SelectTemplate
                            titleText = "Select Template"
                        }
                    }){
                        Image(systemName: "plus").imageScale(.large)
                    }
                }
            }
        }
    }
}

struct FrameCreator_Previews: PreviewProvider {
    static var previews: some View {
        FrameCreator().environmentObject(Hives())
    }
}
