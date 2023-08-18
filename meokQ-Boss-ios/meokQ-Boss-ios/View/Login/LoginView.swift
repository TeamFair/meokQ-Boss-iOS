//
//  LoginView.swift
//  TeamFair
//
//  Created by 077tech on 2023/07/01.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    var buttonAction: () -> Void {
        {
            appState.isLogin = true
            appState.uid = "userIdSample7"
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.LightYellow
                .ignoresSafeArea()
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top, 50)
                Text("맛Q")
                    .font(.system(size: 50).weight(.bold))
                    .foregroundColor(.Yellow)
                    .padding(.bottom, 150)
                VStack(spacing: 27) {
                    KakaoLoginButtonView(buttonAction: buttonAction)
                    GoogleLoginButtonView(buttonAction: buttonAction)
                    AppleLoginButtonView()
                        .environmentObject(appState)
                }
                .padding(.bottom, 100)
                
                NavigationLink(destination: Text("로그인 완료")
                    .environmentObject(appState), isActive: $appState.isLogin) {
                        EmptyView()
                    }
            }
        }
        
        .accentColor(.black)
        .id(appState.roginViewId)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
