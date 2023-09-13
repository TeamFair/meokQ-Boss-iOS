//
//  meokQ_Boss_iosApp.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/16.
//

import SwiftUI
import Firebase
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

let navBarAppearence = UINavigationBarAppearance()

@main
struct meokQ_Boss_iosApp: App {
    
    @StateObject var appState: AppState = AppState()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLogin") var isLogin: Bool = false
    @AppStorage("isFirstLaunch") var isNotFirstLaunch = false
    
    @StateObject var userStore = UserStore()
    
    init() {
        KakaoSDK.initSDK(appKey: "\(AppKeys.KakaoNativeAppKey)")
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
                if isLogin {
                    TabbarView()
                        .environmentObject(appState)
                        .environmentObject(userStore)
                } else {
                    LoginView()
                        .environmentObject(appState)
                        .environmentObject(userStore)
                }
            }
            .tint(.black)
            .onAppear {
                navBarAppearence.configureWithOpaqueBackground()
                navBarAppearence.backgroundColor = .clear
                navBarAppearence.shadowColor = .clear
                UINavigationBar.appearance().standardAppearance = navBarAppearence
                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearence
            }
            .onOpenURL { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    AuthController.handleOpenUrl(url: url)
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure() // 여기 추가
        KakaoSDK.initSDK(appKey: "\(AppKeys.KakaoNativeAppKey)")
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            // Handle other custom URL types.
            return true
        }
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
}


struct AppKeys {
    static let KakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "KakaoNativeAppkey")
}

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
#if DEBUG
    if let obj = object {
        print("\(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : \(obj)")
    } else {
        print("\(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : nil")
    }
#endif
}
