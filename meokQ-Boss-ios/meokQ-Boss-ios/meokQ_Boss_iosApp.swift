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
        }
    }
}
