//
//  UserStore.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/13.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserStore: FirestoreManager {
    
    @Published var user: User = User()
    @Published var coupons: [Coupon] = []
}

// MARK: - User 정보 관련한 함수들
extension UserStore {
    //MARK: 회원탈퇴
    @MainActor
    func deleteDataFromFirestore(uid: String, completion: @escaping ()->Void) async {
        // 삭제할 데이터의 경로 지정
        //let path = "/users/\(uid)" // 예시 경로
        
        
        let deleteMarket: [String: Any] = [
            "isWithdrawal": true,
            "withdrawalTimestamp": Timestamp.init(date: Date.now)
        ]
        
        let marketRef = db.collection("markets").document(uid)
        let userRef = db.collection("users").document(uid)
        
        
        let batch = db.batch()
        
        do {
            if try await marketRef.getDocument().exists {
                batch.updateData(deleteMarket, forDocument: marketRef)
            }
        } catch {
            Log(error)
        }

        batch.deleteDocument(userRef)
        
        do {
            try await batch.commit()
            completion()
            Auth.auth().currentUser?.delete { error in
                if let error = error {
                    // 계정 삭제 중 오류가 발생한 경우 처리
                    Log("Error deleting account: \(error.localizedDescription)")
                } else {
                    // 계정이 성공적으로 삭제된 경우
                    Log("Account deleted successfully.")
                }
            }
        } catch {
            Log(error)
        }
    }
    
    
    @MainActor
    func fetchUser(uid: String) async {
        do {
            
            let docRef = try await db.collection("users").document(uid).getDocument()
            let jsonData = try JSONSerialization.data(withJSONObject: docRef.data() ?? [:])
            let data = try decoder.decode(User.self, from: jsonData)
            user = data
            Log("\(user)")
        } catch {
            Log("\(error)")
        }
    }
    
    @MainActor
    func addNewUser(uid: String, displayName: String) async {
        if await isUserDataExist(uid: uid) {
            return
        }
        
        let data = [
            "displayName": displayName,
            "uid": uid
        ] as [String: Any]
        
        do {
            try await db.collection("users").document(uid).setData(data)
            Log("Successfully written!")
        } catch {
            Log(error)
        }
    }
    
    func isUserDataExist(uid: String) async -> Bool {
        do {
            
            let docRef = try await db.collection("users").document(uid).getDocument()
            guard let data = docRef.data() else {
                Log("UserData not exist")
                return false
            }
            Log("UserData exist")
            return true
        } catch {
            Log("\(error)")
            return false
        }
    }
}

// MARK: - Coupon 관련한 함수들
extension UserStore {
    
    @MainActor
    func fetchUserCoupons(uid: String) async {
        
        do {
            coupons = []
            let querySnapshot = try await db.collection("users").document(uid).collection("coupons_market").getDocuments()
            for document in querySnapshot.documents {
                let documentData = document.data()
                let data = encodeDataToCoupon(documentData: documentData)
                self.coupons.append(data)
                Log(self.coupons)
            }
        } catch {
            Log(error)
        }
    }
    
    @MainActor
    func useCoupon(uid: String, couponId: String) async {
        
        // Timestamp.init(date: Date.now)
        let data: [String: Any] = [
            "modifiedTimestamp" : Timestamp.init(date: Date.now),
            "redeemedTimestamp" : Timestamp.init(date: Date.now),
            "status" : "redeemed"
        ]
        do {
            try await db.collection("users").document(uid).collection("coupons_market").document(couponId).updateData(data)
        } catch {
            Log(error)
        }
    }
}
