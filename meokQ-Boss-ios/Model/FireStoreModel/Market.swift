//
//  Market.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation


class Market: DocumentTimestamp, ObservableObject {
    let uuid = UUID()
    @Published var address = ""
    @Published var businessOwnerId = ""
    @Published var closingTime = ""
    @Published var district = ""
    @Published var marketId = ""
    @Published var marketImages = ""
    @Published var missionCount = 0
    @Published var name = ""
    @Published var openingTime = ""
    @Published var phoneNumber = ""
}

extension Market: Hashable {
    
    static func == (lhs: Market, rhs: Market) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
