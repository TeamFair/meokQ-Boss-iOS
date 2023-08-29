//
//  MarketStore.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation
import FirebaseFirestore
import OSLog

class MarketStore: ObservableObject {
    @Published var currentMarket: Market?
    @Published var changeCount: Int = 0
    
    let db = Firestore.firestore()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
}

extension MarketStore {
    @MainActor
    func fetchMarketDetail(district: String, marketId: String) async {
        do {
            let querySnapshot = try await db.collection("markets/\(marketId)").whereField("district", isEqualTo: district).getDocuments()
            for document in querySnapshot.documents {
                let marketData = try JSONSerialization.data(withJSONObject: document.data())
                let market = try try self.decoder.decode(Market.self, from: marketData)
                self.currentMarket = market
            }
            Log("\(self.currentMarket)")
        } catch {
            Log("\(error)")
        }
    }
  
    func addQuest(district: String, marketId: String, content: String, reward: String) {
        let missionId = UUID().uuidString
        let nowDate = Date() // 현재의 Date (ex: 2020-08-13 09:14:48 +0000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2020-08-13 16:30
        let dateStr = dateFormatter.string(from: nowDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
        self.marketDatabasePath?.child(district).child(marketId).child("missions").child(missionId).setValue([
            "content": content,
            "reward": reward,
            "date": dateStr
        ] as [String : Any])
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
