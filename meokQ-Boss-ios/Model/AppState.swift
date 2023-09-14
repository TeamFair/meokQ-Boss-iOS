//
//  AppState.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/16.
//

import Foundation


final class AppState : ObservableObject {
    @Published var loginViewId: UUID
    @Published var homeViewId: UUID
    @Published var uid: String?
    
    init(loginViewId: UUID = UUID(), homeViewId: UUID = UUID(), uid: String? = nil) {
        self.loginViewId = loginViewId
        self.homeViewId = homeViewId
        self.uid = uid
    }
}
