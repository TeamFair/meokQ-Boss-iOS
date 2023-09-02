//
//  FirestoreManager.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/30.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


class FirestoreManager: ObservableObject {
    
    let db = Firestore.firestore()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
}

extension FirestoreManager {
    func encodeDataToMarket(documentData: [String : Any]) -> Market {
        
        var data: Market = Market()
        
        data.address = documentData["address"] as? String ?? ""
        data.businessOwnerId = documentData["businessOwnerId"] as? String ?? ""
        data.closingTime = documentData["closingTime"] as? String ?? ""
        if let timestamp = documentData["createdTimestamp"] as? Timestamp {
            data.createdTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        data.district = documentData["district"] as? String ?? ""
        data.marketId = documentData["marketId"] as? String ?? ""
        data.marketImages = documentData["marketImages"] as? String ?? ""
        data.missionCount = documentData["missionCount"] as? Int ?? 0
        if let timestamp = documentData["modifiedTimestamp"] as? Timestamp {
            data.createdTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        data.name = documentData["name"] as? String ?? ""
        data.openingTime = documentData["openingTime"] as? String ?? ""
        data.phoneNumber = documentData["phoneNumber"] as? String ?? ""
        return data
    }
    
    func encodeDataToMission(documentData: [String : Any]) -> Mission {
        
        var data: Mission = Mission()
        if let timestamp = documentData["createdTimestamp"] as? Timestamp {
            data.createdTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        data.missionDescription = documentData["missionDescription"] as? String ?? ""
        data.missionId = documentData["missionId"] as? String ?? ""
        data.status = documentData["status"] as? String ?? ""
        if let timestamp = documentData["modifiedTimestamp"] as? Timestamp {
            data.modifiedTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        data.paidStatus = documentData["paidStatus"] as? Bool ?? false
        data.reward = documentData["reward"] as? String ?? ""
        return data
    }
    
    func encodeDataToRequest(documentData: [String : Any]) -> Request {
        
        var data: Request = Request()
        data.marketId = documentData["marketId"] as? String ?? ""
        data.message = documentData["message"] as? String ?? ""
        data.missionId = documentData["missionId"] as? String ?? ""
        data.missionVerificationRequestImage = documentData["missionVerificationRequestImage"] as? String ?? ""
        data.userId = documentData["userId"] as? String ?? ""
        data.status = documentData["status"] as? String ?? ""
        
        if let timestamp = documentData["createdTimestamp"] as? Timestamp {
            data.createdTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        if let timestamp = documentData["modifiedTimestamp"] as? Timestamp {
            data.modifiedTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        return data
    }
    
    func encodeDataToCoupon(documentData: [String : Any]) -> Coupon {
        
        var data: Coupon = Coupon()
        data.marketId = documentData["marketId"] as? String ?? ""
        data.reward = documentData["reward"] as? String ?? ""
        data.status = documentData["status"] as? String ?? ""
        data.userId = documentData["userId"] as? String ?? ""
        data.couponId = documentData["couponId"] as? String ?? ""
        
        if let timestamp = documentData["createdTimestamp"] as? Timestamp {
            data.createdTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        if let timestamp = documentData["expiryTimestamp"] as? Timestamp {
            data.expiryTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        if let timestamp = documentData["issuedTimestamp"] as? Timestamp {
            data.issuedTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        if let timestamp = documentData["modifiedTimestamp"] as? Timestamp {
            data.modifiedTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        if let timestamp = documentData["redeemedTimestamp"] as? Timestamp {
            data.redeemedTimestamp = timestamp.dateValue().addingTimeInterval(3600 * 9)
        }
        return data
    }
}
