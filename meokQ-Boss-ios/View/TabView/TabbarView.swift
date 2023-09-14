//
//  TabbarView.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/23.
//

import SwiftUI

struct TabbarView: View {
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @State var viewTitle = ""
    @StateObject var marketStore = MarketStore()
    @EnvironmentObject var appState: AppState
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(named: "Tabbar")
    }
    
    var body: some View {
        TabView {
            QuestView(viewTitle: $viewTitle, marketStore: marketStore)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("퀘스트")
                }
                .navigationBarBackButtonHidden()
            
            ReceiptView(viewTitle: $viewTitle, marketStore: marketStore)
                .tabItem{
                    Image(systemName: "wallet.pass.fill")
                    Text("영수증")
                }
                .navigationBarBackButtonHidden()
            
            StatisticsView(viewTitle: $viewTitle, marketStore: marketStore)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("통계")
                }
                .navigationBarBackButtonHidden()
        }
        .navigationTitle(viewTitle)
        .navigationBarTitleDisplayMode(.inline)
        .tint(.black)
        .task {
            await marketStore.fetchUser()
            await marketStore.fetchMarket(marketId: uid)
        }
        .navigationBarBackButtonHidden(isLogin)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingView().environmentObject(appState)) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.black)
                        .opacity(isLogin ? 1 : 0)
                }
            }
        }
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
