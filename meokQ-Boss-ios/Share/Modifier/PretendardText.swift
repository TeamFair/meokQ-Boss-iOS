//
//  PretendardText.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/14.
//

import SwiftUI

struct PretendardText: ViewModifier {
    
    @State var fontweight: Font.Weight = .regular
    @State var fontsize: CGFloat = 16
    
    func body(content: Content) -> some View {
        
        switch fontweight {
            
        case .light:
            content.font(.custom("Pretendard-Light", size: fontsize))
        case .regular:
            content.font(.custom("Pretendard-Regular", size: fontsize))
        case .semibold:
            content.font(.custom("Pretendard-SemiBold", size: fontsize))
        case .bold:
            content.font(.custom("Pretendard-Bold", size: fontsize))
        default:
            content.font(.custom("Pretendard-Regular", size: fontsize))
        }
    }
}

