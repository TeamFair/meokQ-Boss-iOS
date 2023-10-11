//
//  RecieptView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/19.
//

import SwiftUI

// 영수증 Tab입니다.

struct ReceiptView: View {
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @Binding var viewTitle: String
    @ObservedObject var marketStore: MarketStore
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color.LightYellow
                .ignoresSafeArea()
            VStack (spacing:0){
                if marketStore.requests.isEmpty {
                    Text("승인할 영수증이 없습니다")
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible())],spacing: 16) {
                            ForEach(marketStore.requests, id: \.self) { request in
                                NavigationLink(destination: ReceiptCheckView(request: request, marketStore: marketStore)) {
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
            }
        }
        .task {
            viewTitle = "영수증"
            await marketStore.fetchAllMarketCompletionMissions(marketId: uid)
        }
    }
}

struct ReceiptView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptView(viewTitle: .constant("영수증"),marketStore: MarketStore())
            .environmentObject(AppState(uid: "marketIdSample1"))
    }
}

