//
//  Setting.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/14.
//

import Foundation

enum SettingType {
    case LogOut
    case Quit
}

struct Setting {
    let title: String
    let type: SettingType
}
