//
//  AppState.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/16.
//

import Foundation


final class AppState : ObservableObject {
    @Published var isLogin: Bool
    @Published var roginViewId: UUID
    @Published var homeViewId: UUID
    @Published var uid: String?
    
    init(isLogin: Bool = false, roginViewId: UUID = UUID(), homeViewId: UUID = UUID(), uid: String? = nil) {
        self.isLogin = isLogin
        self.roginViewId = roginViewId
        self.homeViewId = homeViewId
        self.uid = uid
    }
}
