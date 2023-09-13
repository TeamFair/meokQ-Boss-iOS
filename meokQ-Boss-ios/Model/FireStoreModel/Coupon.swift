//
//  Coupon.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/30.
//

import Foundation

class Coupon: DocumentTimestamp {
    
    let uuid = UUID()
    
    var couponId = ""
    var marketId = ""
    var missionId = ""
    var expiryTimestamp = Date()
    var issuedTimestamp = Date()
    var redeemedTimestamp = Date()
    var reward = ""
    var missionDescription = ""
    var status = ""
    var userId = ""
    var userDisplayName = ""
    
    
    init(expiryTimestamp: Date = Date(), issuedTimestamp: Date = Date(), marketId: String = "", redeemedTimestamp: Date = Date(), reward: String = "", status: String = "", userId: String = "", documentTimestamp: DocumentTimestamp = DocumentTimestamp()) {
        super.init(createdTimestamp: documentTimestamp.createdTimestamp, modifiedTimestamp: documentTimestamp.modifiedTimestamp)
        self.expiryTimestamp = expiryTimestamp
        self.issuedTimestamp = issuedTimestamp
        self.marketId = marketId
        self.redeemedTimestamp = redeemedTimestamp
        self.reward = reward
        self.status = status
        self.userId = userId
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

extension Coupon: Hashable {
    
    static func == (lhs: Coupon, rhs: Coupon) -> Bool {
        lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
