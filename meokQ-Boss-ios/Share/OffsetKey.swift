//
//  OffsetKey.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/14.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
