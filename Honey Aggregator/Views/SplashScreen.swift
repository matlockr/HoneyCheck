//
//  SplashScreen.swift
//  Honey Aggregator
//
//  Created by Robert Matlock on 5/23/21.
//

import SwiftUI

struct SplashScreen: View {
    
    @Binding var showingIcon: Bool
    @Binding var showNavBar: Bool
    
    var body: some View {
        ZStack(alignment: .center){
            Image("comb")
                .aspectRatio(contentMode: .fit)
                .background(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            .transition(.scale)
        }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                showingIcon = false
                showNavBar = false
            })
        })
    }
}
