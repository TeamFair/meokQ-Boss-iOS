//
//  LoginButton.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/16.
//

import Foundation
import SwiftUI

enum LoginButton {
    case kakao
    case google
    case apple
    
    var imageName: String {
        switch self {
        case .kakao:
            return "KakaoLogo"
        case .google:
            return "GoogleLogo"
        case .apple:
            return "AppleLogo"
        }
    }
    
    var labelText: String {
        switch self {
        case .kakao:
            return "Login with Kakao"
        case .google:
            return "Sign in with Google"
        case .apple:
            return "Sign in with Apple"
        }
    }
    
    var fontName: String {
        switch self {
        case .kakao:
            return "AppleSDGothicNeoR00"
        case .google:
            return "Roboto"
        case .apple:
            return "SF Pro Display"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .kakao:
            return .KakaoAccentColor
        case .google:
            return .GoogleAccentColor
        case .apple:
            return .AppleAccentColor
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .kakao:
            return .KakakoBackground
        case .google:
            return .GoogleBackground
        case .apple:
            return .AppleBackground
        }
    }
}
