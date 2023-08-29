//
//  LoginView.swift
//  TeamFair
//
//  Created by 077tech on 2023/07/01.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @StateObject var marketStore = MarketStore()
    @StateObject var requestStore = RequestStore()
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
                
                NavigationLink(destination: TabbarView()
                    .environmentObject(appState), isActive: $appState.isLogin) {
                        EmptyView()
                    }
            }
        }
        .accentColor(.black)
        .id(appState.roginViewId)
        .task {
            await marketStore.fetchMarketDetail(district: "1114000000", marketId: "marketIdSample1")
            marketStore.addQuest(district: "1114000000", marketId: "marketIdSample5", content: "이건 테스트 퀘스트", reward: "이건 테스트 보상")
            await requestStore.fetchRequests(marketId: "marketIdSample1")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
