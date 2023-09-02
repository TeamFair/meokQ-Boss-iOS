//
//  MarketStore.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation
import Firebase

class MarketStore: FirestoreManager {
    @Published var market: Market = Market()
    @Published var changeCount: Int = 0
    
    @Published var mission: Mission = Mission()
    @Published var missions: [Mission] = []
    
    @Published var requests: [Request] = []
}

extension MarketStore {
    @MainActor
    func fetchMarket(marketId: String) async {
        do {
            guard let documentData = try await db.collection("markets").document(marketId).getDocument().data() else {
                Log("guard else")
                return
            }
            let data = encodeDataToMarket(documentData: documentData)
            self.market = data
        } catch {
            Log("\(error)")
        }
    }
  
    @MainActor
    func addMission(marketId: String, missionDescription: String, reward: String, missionCount: Int) async {
        let missionId = UUID().uuidString

        let missionData: [String: Any] = [
            "createdTimestamp" : Timestamp.init(date: Date.now),
            "missionId": marketId,
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
    func fetchAllMarketMissions(marketId: String) async {
        
        do {
            self.missions = []
            let querySnapshot = try await db.collection("markets")
                .document(marketId)
                .collection("missions_market")
                .whereField("paidStatus", isEqualTo: true)
                .getDocuments()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                let data = encodeDataToMission(documentData: documentData)
                self.missions.append(data)
                Log(self.missions)
            }
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func fetchAllMarketCompletionMissions(marketId: String) async {
        
        do {
            self.missions = []
            let querySnapshot = try await db.collection("markets")
                .document(marketId)
                .collection("completion_requests_mission")
                .whereField("status", isEqualTo: "pending")
                .getDocuments()
            
            for document in querySnapshot.documents {
                let documentData = document.data()
                let data = encodeDataToRequest(documentData: documentData)
                self.requests.append(data)
                Log(self.missions)
            }
        } catch {
            Log(error)
        }
    }
    
    
//    func fetchMissionStatus(district: String, marketId: String) {
//        guard let databasePath = self.missionStatusDatabasePath?.child(marketId) else {
//            return
//        }
//
//        databasePath.observe(.value) { [weak self] snapshot, _ in
//            guard let self = self else {
//                return
//            }
//
//            if let json = snapshot.value as? [String: Any] {
//                do {
//                    let missionStatusData = try JSONSerialization.data(withJSONObject: json)
//                    let missionStatus = try self.decoder.decode([String: UserInfo].self, from: missionStatusData)
//                    completion(missionStatus)
//                } catch {
//                    completion(nil)
//                }
//            }
//        }
//    }
}
