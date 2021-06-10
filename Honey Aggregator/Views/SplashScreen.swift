import SwiftUI

struct SplashScreen: View {
    
    // Binding variables from ContentView that tell UI to show/hide
    @Binding var showingIcon: Bool
    @Binding var showNavBar: Bool
    
    var body: some View {
        ZStack(alignment: .center){
            Image("appLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .padding()
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                showingIcon = false
                showNavBar = false
            })
        })
    }
}
