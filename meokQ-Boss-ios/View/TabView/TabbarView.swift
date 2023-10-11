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
    
    @State var selectedTab: Int
    @State var viewTitle = ""
    @State var mode: EditedMode = .view
    @EnvironmentObject var marketStore: MarketStore
    @EnvironmentObject var appState: AppState
    
    init(selectedTab: Int) {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(named: "Tabbar")
        self.selectedTab = selectedTab
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            QuestView(viewTitle: $viewTitle, marketStore: marketStore)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("퀘스트")
                }
                .navigationBarBackButtonHidden()
                .tag(0)
            
            ReceiptView(viewTitle: $viewTitle, marketStore: marketStore)
                .tabItem{
                    Image(systemName: "wallet.pass.fill")
                    Text("영수증")
                }
                .navigationBarBackButtonHidden()
                .tag(1)
            
            StatisticsView(viewTitle: $viewTitle, marketStore: marketStore)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("통계")
                }
                .navigationBarBackButtonHidden()
                .tag(2)
            
            ProfileView(viewTitle: $viewTitle, mode: $mode, marketStore: marketStore)
                .tabItem {
                    Image(systemName: "person")
                    Text("내 정보")
                }
                .navigationBarBackButtonHidden()
                .tag(3)
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
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: SettingView().environmentObject(appState)) {
                    Image(systemName: "gearshape")
                        .opacity(isLogin ? 1 : 0)
                }
                .tint(.black)
            }
        }
    }
}

struct Tabview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TabbarView(selectedTab: 3)
                .environmentObject(AppState(uid: "marketIdSample2"))
        }
    }
}
