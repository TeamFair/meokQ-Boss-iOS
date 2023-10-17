//
//  MarketStore.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation
import FirebaseFirestore

class MarketStore: FirestoreManager {
    @Published var market: Market = Market()
    @Published var changeCount: Int = 0
    
    @Published var mission: Mission = Mission()
    @Published var missions: [String: Mission] = [:]
    @Published var requests: [Request] = []
    @Published var coupons: [Coupon] = []
    @Published var users: [User] = []
}

extension MarketStore {
    @MainActor
    func fetchMarket(marketId: String) async {
        if marketId == "" {
            Log("not marketId")
            return
        }
        
        do {
            guard let documentData = try await db.collection("markets").document(marketId).getDocument().data() else {
                Log("guard else")
                return
            }
            let data = encodeDataToMarket(documentData: documentData)
            self.market = data
            Log(self.market)
        } catch {
            Log("\(error)")
        }
    }
  
    @MainActor
    func updateMarket(marketId: String) async {
        if marketId == "" {
            Log("No marketId")
        }
        
        for district in District.allCases {
            if market.address.contains(district.rawValue) {
                market.district = district.districtCode
            }
        }
        
        let marketData: [String: Any] = [
            "marketId": market.marketId,
            "businessOwnerId": market.marketId,
            "district": market.district,
            "logoImage": market.marketImages,
            "address": market.address,
            "missionCount": market.missionCount,
            "name": market.name,
            "openingTime": market.openingTime,
            "closingTime": market.closingTime,
            "phoneNumber" : market.phoneNumber,
            "createdTimestamp": market.createdTimestamp,
            "modifiedTimestamp": Timestamp.init(date: Date.now),
            "withdrawalTimestamp": "",
            "isWithdrawal": false
        ]
        
        let MarketRef = db.collection("markets").document(marketId)
        let batch = db.batch()
        
        do {
            if try await MarketRef.getDocument().exists {
                batch.updateData(marketData, forDocument: MarketRef)
            } else {
                batch.setData(marketData, forDocument: MarketRef)
            }
        } catch {
            Log(error)
        }
        
        do {
            try await batch.commit()
            Log("Batch write succeeded")
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func addMission(marketId: String, missionDescription: String, reward: String, missionCount: Int) async {
        if marketId == "" {
            return
        }
        
        let missionId = UUID().uuidString

        let missionData: [String: Any] = [
            "createdTimestamp" : Timestamp.init(date: Date.now),
            "missionId": missionId,
            "missionDescription": missionDescription,
            "modifiedTimestamp": Timestamp.init(date: Date.now),
            "paidStatus": true,
            "reward": reward,
            "status": "approved"
        ]

        let missionCount: [String: Any] = [
            "missionCount": missionCount - 1
        ]

        let MissionDocRef =  db
            .collection("markets").document(marketId)
            .collection("missions_market").document(missionId)

        let MarketDocRef = db
            .collection("markets").document(marketId)

        let batch = db.batch()

        batch.setData(missionData, forDocument: MissionDocRef)
        batch.updateData(missionCount, forDocument: MarketDocRef)

        do {
            try await batch.commit()
            Log("Batch write succeeded")
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func addCoupon(marketId: String, userId: String, reward: String, missionId: String, requestId: String) async {
        if marketId == "" {
            return
        }
        
        let couponId = UUID().uuidString

        let couponData: [String: Any] = [
            "couponId": couponId,
            "marketId": marketId,
            "userId": userId,
            "missionId": missionId,
            "reward": reward,
            "status": "issued",
            "issuedTimestamp": Timestamp.init(date: Date.now),
            "expiryTimestamp": Timestamp.init(date: Date.now),
            "redeemedTimestamp": "",
            "createdTimestamp" : Timestamp.init(date: Date.now),
            "modifiedTimestamp": Timestamp.init(date: Date.now)
        ]
        
        let requestStatus: [String: String] = [
            "status": "approved"
        ] 
        
        let MissionRequestRef = db
            .collection("markets").document(marketId)
            .collection("completion_requests_mission").document(requestId)
        
        let UserCouponsRef = db
            .collection("users").document(userId)
            .collection("coupons_market").document(couponId)
        
        let batch = db.batch()
        
        batch.updateData(requestStatus, forDocument: MissionRequestRef)
        batch.setData(couponData, forDocument: UserCouponsRef)
        
        do {
            try await batch.commit()
            Log("Batch write succeeded")
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func fetchAllMarketMissions(marketId: String) async {
        if marketId == "" {
            return
        }
        
        do {
            var newMissions: [Mission] = []
            let querySnapshot = try await db.collection("markets")
                .document(marketId)
                .collection("missions_market")
                .whereField("paidStatus", isEqualTo: true)
                .getDocuments()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                let data = encodeDataToMission(documentData: documentData)
                newMissions.append(data)
            }
            
            self.missions = Dictionary(uniqueKeysWithValues: newMissions.map { ($0.missionId, $0) })
            Log(self.missions)
        } catch {
            Log(error)
        }
    }
    
    
    @MainActor
    func fetchAllMarketCompletionMissions(marketId: String) async {
        if marketId == "" {
            return
        }
        
        do {
            self.requests = []
            let querySnapshot = try await db.collection("markets")
                .document(marketId)
                .collection("completion_requests_mission")
                .whereField("status", isEqualTo: "pending")
                .getDocuments()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                let data = encodeDataToRequest(documentData: documentData)
                
                if let reward = self.missions[data.missionId]?.reward {
                    data.reward = reward
                }
                if let missionDescription = self.missions[data.missionId]?.missionDescription {
                    data.missionDescription = missionDescription
                }
                
                self.requests.append(data)
                Log(self.missions)
            }
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func rejectRequest(marketId: String, missionId: String, requestId: String, message: String) async {
        if marketId == "" {
            return
        }
        
        let requestStatus: [String: Any] = [
            "status": "rejected",
            "message": message,
            "modifiedTimestamp": Timestamp.init(date: Date.now)
        ]
        
//        createdTimestamp
//        marketId
//        message
//        missionId
//        missionVerificationRequestImage
//        modifiedTimestamp
//        requestId
//        status
//        userId
        
        let MissionRequestRef = db
            .collection("markets").document(marketId)
            .collection("completion_requests_mission").document(requestId)
        
        let batch = db.batch()
                
        batch.updateData(requestStatus, forDocument: MissionRequestRef)
        
        do {
            try await batch.commit()
            Log("Batch write succeeded")
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func fetchCouponStatistics(marketId: String) async {
        if marketId == "" {
            return
        }
        self.coupons = []
        do {
            for user in users {
                let querySnapshot = try await db.collection("users")
                    .document(user.uid)
                    .collection("coupons_market")
                    .whereField("marketId", isEqualTo: marketId)
                    .getDocuments()
                
                for document in querySnapshot.documents {
                    let documentData = document.data()
                    let data = encodeDataToCoupon(documentData: documentData)
                    data.userDisplayName = user.displayName
                    
                    print(data.missionId)
                    if let missionDescription = missions[data.missionId]?.missionDescription {
                        data.missionDescription = missionDescription
                    }
                    self.coupons.append(data)
                }
            }
            Log(self.coupons)
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func fetchUser() async {
        do {
            self.users = []
            let querySnapshot = try await db.collection("users")
                .getDocuments()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                let data = encodeDataToUser(documentData: documentData)
                self.users.append(data)
            }
            Log(self.users)
        } catch {
            Log(error)
        }
    }
}
