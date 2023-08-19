//
//  meokQ_Boss_iosApp.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/16.
//

import SwiftUI
import Firebase

@main
struct meokQ_Boss_iosApp: App {
    
    @ObservedObject var appState: AppState = AppState()
    
    init() {
        FirebaseApp.configure()
        Font.registerFonts(fontName: "Pretendard-Bold")
        Font.registerFonts(fontName: "Pretendard-Light")
        Font.registerFonts(fontName: "Pretendard-Regular")
        Font.registerFonts(fontName: "Pretendard-SemiBold")
        Font.registerFonts(fontName: "AppleSDGothicNeoR")
        Font.registerFontsttf(fontName: "Roboto-Regular") // ttf
        Font.registerFontsttf(fontName: "Roboto-Medium") // ttf
        Font.registerFonts(fontName: "SFPRODISPLAYREGULAR")
        Font.registerFonts(fontName: "SFPRODISPLAYMEDIUM")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView()
                    .environmentObject(appState)
            }
//            NavigationView{
//                TabView {
//                    QuestView()
//                        .tabItem {
//                            Image(systemName: "star.fill")
//                            Text("퀘스트")
//                        }
//                    ReceiptView()
//
//                        .tabItem{
//                            Image(systemName: "wallet.pass.fill")
//                            Text("영수증")
//                        }
//
//                    StatisticsView()
//
//                        .tabItem {
//                            Image(systemName: "chart.bar.fill")
//                            Text("통계")
//                        }
//                }
//            }
            
            
        }
    }
}
