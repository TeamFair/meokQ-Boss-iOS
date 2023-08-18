//
//  Font.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/16.
//

import SwiftUI

extension Font {
    public static func registerFonts(fontName: String) {
        registerFont(bundle: Bundle.main , fontName: fontName, fontExtension: ".otf") //change according to your ext.
    }
    public static func registerFontsttf(fontName: String) {
        registerFont(bundle: Bundle.main , fontName: fontName, fontExtension: ".ttf") //change according to your ext.
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {

        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }

        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
