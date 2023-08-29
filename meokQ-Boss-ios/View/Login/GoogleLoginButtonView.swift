//
//  GoogleLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI

struct GoogleLoginButtonView: View {
    var buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction) {
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(LoginButton.google.backgroundColor)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                HStack {
                    Image(LoginButton.google.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    Spacer()
                    Text(LoginButton.google.labelText)
                        .foregroundColor(LoginButton.google.accentColor)
//                        .font(.system(size: 14).weight(.medium))
                        .font(.custom("Roboto-Medium", size: 14))
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
            .frame(width: 250, height: 50)
        }
    }
}


struct GoogleLoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginButtonView(buttonAction: {})
    }
}
