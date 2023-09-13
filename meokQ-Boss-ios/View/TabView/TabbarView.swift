//
//  TabbarView.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/23.
//

import SwiftUI

struct TabbarView: View {
    @StateObject var marketStore = MarketStore()
    @EnvironmentObject var appState: AppState
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(named: "Tabbar")
    }
    
    var body: some View {
        TabView {
            QuestView(marketStore: marketStore)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("퀘스트")
                }
                .navigationBarBackButtonHidden()
            
            ReceiptView(marketStore: marketStore)
                .tabItem{
                    Image(systemName: "wallet.pass.fill")
                    Text("영수증")
                }
                .navigationBarBackButtonHidden()
            
            StatisticsView(marketStore: marketStore)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("통계")
                }
                .navigationBarBackButtonHidden()
        }
        .tint(.black)
        .task {
            if let marketId = appState.uid {
                await marketStore.fetchUser()
                await marketStore.fetchMarket(marketId: marketId)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct Tabview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TabbarView()
                .environmentObject(AppState(uid: "marketIdSample2"))
        }
    }
}
