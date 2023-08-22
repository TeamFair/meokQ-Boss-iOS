//
//  RequestStore.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift



class RequestStore: ObservableObject {
    @Published var requests: [String: Request]?
    @Published var isMarketNone: Bool = false
    
    let ref: DatabaseReference? = Database.database().reference()
    var requestDatabasePath: DatabaseReference? {
        ref?.child("requestCoupons")
    }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func stopListening() {
        ref?.removeAllObservers()
    }
}

extension RequestStore {
    @MainActor
    func fetchRequests(marketId: String) async {
        guard let databasePath = self.requestDatabasePath?.child(marketId) else {
            return
        }
        
        databasePath.observe(.value) { [weak self] snapshot, _  in
            guard let self = self else {
                return
            }
            print(snapshot)
            if let json = snapshot.value as? [String: Any] {
                do {
                    let requestsData = try JSONSerialization.data(withJSONObject: json)
                    let requests = try self.decoder.decode([String: Request].self, from: requestsData)
                    self.requests = requests
                    print(self.requests)
                    isMarketNone = false
                } catch {
                    print("an error occurred", error)
                }
            } else {
                self.requests = [:]
                isMarketNone = true
            }
        }
    }
}
