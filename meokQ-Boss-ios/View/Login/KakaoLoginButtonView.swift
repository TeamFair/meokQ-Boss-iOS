//
//  KakaoLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI

struct KakaoLoginButtonView: View {
    var buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(LoginButton.kakao.backgroundColor)
                HStack {
                    Image(LoginButton.kakao.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    Spacer()
                    Text(LoginButton.kakao.labelText)
                        .foregroundColor(LoginButton.kakao.accentColor)
                        .font(.custom("AppleSDGothicNeoR00", size: 14))
                        
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
            .frame(width: 250, height: 50)
        }
    }
}

struct KakaoLoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        KakaoLoginButtonView(buttonAction: {})
    }
}
