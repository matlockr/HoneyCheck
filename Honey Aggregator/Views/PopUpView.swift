//
//  PopUpView.swift
//  Honey Aggregator
//
//  Created by Nico Morales on 4/8/21.
//
//  Special thanks to John Codeos
//  https://johncodeos.com/how-to-create-a-popup-window-with-swiftui/

import SwiftUI

struct PopUpView: View {
    @Environment(\.presentationMode) var presentationMode
    var title: String
        var message: String
        var buttonText: String
        //@Binding var show: Bool

        var body: some View {
            ZStack {
                //if show {
                    // PopUp background color
                    //Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)

                    // PopUp Window
                    VStack(alignment: .center, spacing: 0) {
                        Text(title)
                            .frame(maxWidth: .infinity)
                            .frame(height: 45, alignment: .center)
                            .font(Font.system(size: 23, weight: .semibold))
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))

                        Text(message)
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 16, weight: .semibold))
                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 20, trailing: 25))
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))

                        Button(action: {
                            // Dismiss the PopUp
                            withAnimation(.linear(duration: 0.3)) {
                                self.presentationMode.wrappedValue.dismiss()
                                //show = false
                            }
                        }, label: {
                            Text(buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54, alignment: .center)
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                .background(Color(#colorLiteral(red: 0.9737995267, green: 0.7765005827, blue: 0.08046276122, alpha: 1)))
                                .font(Font.system(size: 23, weight: .semibold))
                        }).buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: 300)
                    .border(Color(#colorLiteral(red: 0.9737995267, green: 0.7765005827, blue: 0.08046276122, alpha: 1)), width: 2)
                    .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                }
        }
}

