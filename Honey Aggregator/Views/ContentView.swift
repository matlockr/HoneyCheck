//
//  ContentView.swift
//  Honey Aggregator
//
//  Main Screen of the app
//

import SwiftUI

struct ContentView: View {

    // Singleton object that holds list of hives
    @EnvironmentObject var hives:Hives
        
    var body: some View {
        NavigationView{
            
            // The only item on the view is the readout from the hives objects
            VStack{
                Text("\(hives.readOut)")
            }
            .navigationBarItems(leading: Text("Honey Aggregator"))
            // Toolbar setup for the navigation buttons on the top of the view
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    // Navigation link to the FrameCreator view
                    NavigationLink(destination: FrameCreator().environmentObject(hives)){
                        Image(systemName: "plus").imageScale(.large)
                    }
                    
                    // Navigation Link to the SettingsMenu view
                    NavigationLink(destination: SettingsMenu().environmentObject(hives)){
                        Image(systemName: "gearshape.fill").imageScale(.large)
                    }
                }
            }
        }
        .onAppear(perform: {
            // Get the readout the first time to setup the readout string
            hives.readOut = hives.getReadOut()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Hives())
    }
}
