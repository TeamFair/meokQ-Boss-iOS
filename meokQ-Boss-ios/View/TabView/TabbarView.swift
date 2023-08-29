//
//  TabbarView.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/23.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        NavigationView {
            TabView {
                QuestView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("퀘스트")
                    }
                ReceiptView()

                    .tabItem{
                        Image(systemName: "wallet.pass.fill")
                        Text("영수증")
                    }

                StatisticsView()

                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("통계")
                    }
            }
        }
    }
}

struct Tabview_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
            .environmentObject(AppState())
    }
}
