//
//  RecieptView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/19.
//

import SwiftUI

// 영수증 Tab입니다.

struct ReceiptView: View {
    @StateObject var marketStore = MarketStore()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
            VStack (spacing:0){
                ScrollView {
                    
                    HStack{
                        Text("영수증")
                            .font(Font.custom("Pretendard", size: 34)
                                .weight(.bold))
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.top, 23)
                    
                    LazyVGrid(columns: [GridItem(.flexible())],spacing: 16) {
                        ForEach(marketStore.requests, id: \.self) { request in
                            NavigationLink(destination: ReceiptCheckView(request: request)) {
                                ReceiptComponent(request: request)
                            }
                        }
                        .tint(.black)
                    }.shadow(color: .black.opacity(0.16), radius: 10, x: 0, y: 0)
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                }
                Spacer()
            }
            .background(Color.LightYellow)
            .task {
                if let marketId = appState.uid {
                    await marketStore.fetchAllMarketCompletionMissions(marketId: marketId)
                }
            }
        
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptView()
            .environmentObject(AppState(uid: "marketIdSample1"))
    }
}

