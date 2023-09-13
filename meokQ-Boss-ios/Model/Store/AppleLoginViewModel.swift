//
//  AppleLoginViewModel.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/13.
//

import AuthenticationServices
import CryptoKit
import Firebase

class AppleLoginViewModel: ObservableObject {
    
    @Published var currentNonce = ""
    var result: AuthDataResult?
    var firebaseuid: String = ""
    //  @AppStorage("firebaseuid") var firebaseuid = ""
    
    func authenticate(credential: ASAuthorizationAppleIDCredential) async {
        
        guard let token = credential.identityToken else {
            Log("error with firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            Log("error with token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: currentNonce
        )
        do {
            result = try await Auth.auth().signIn(with: firebaseCredential)
            guard let result = result else {
                return
            }
            self.result = result
            self.firebaseuid = result.user.uid
            Log("UID: \(result.user.uid)")
            Log("로그인 완료")
        } catch {
            Log(error)
        }
    }
}
