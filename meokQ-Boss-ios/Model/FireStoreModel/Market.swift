//
//  Market.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation


class Market: DocumentTimestamp {
    let uuid = UUID()
    var address = ""
    var businessOwnerId = ""
    var closingTime = ""
    var district = ""
    var marketId = ""
    var marketImages = ""
    var missionCount = 0
    var name = ""
    var openingTime = ""
    var phoneNumber = ""
}

extension Market: Hashable {
    
    static func == (lhs: Market, rhs: Market) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
