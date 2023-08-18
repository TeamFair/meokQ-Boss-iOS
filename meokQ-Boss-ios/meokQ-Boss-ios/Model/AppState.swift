//
//  AppState.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/16.
//

import Foundation


final class AppState : ObservableObject {
    @Published var isLogin = false
    @Published var roginViewId = UUID()
    @Published var homeViewId = UUID()
    @Published var uid: String?
}
