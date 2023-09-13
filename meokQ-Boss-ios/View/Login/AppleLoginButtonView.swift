//
//  AppleLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI
import CryptoKit
import _AuthenticationServices_SwiftUI

struct AppleLoginButtonView: View {
    
    @EnvironmentObject var userViewModel: UserStore
    @EnvironmentObject var appState: AppState
    @StateObject var appleLoginViewModel = AppleLoginViewModel()
    
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @State var fullName = ""
    
    var body: some View {
        SignInWithAppleButton { (request) in
            
            appleLoginViewModel.currentNonce = randomNonceString()
            request.requestedScopes = [.email, .fullName]
            request.nonce = sha256(appleLoginViewModel.currentNonce)
        } onCompletion: { (result) in
            
            switch result {
            case .success(let user):
                Task {
                    
                    guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                        Log("error with firebase")
                        return
                    }
                    if let fullName = credential.fullName {
                        self.fullName = "\(fullName.familyName ?? "")" + "\(fullName.givenName ?? "")"
                        Log(self.fullName)
                    }
                    if let email = credential.email {
                        Log(email)
                    }
                    Log(credential.user)
                    await appleLoginViewModel.authenticate(credential: credential)
                    self.uid = appleLoginViewModel.firebaseuid
                    appState.uid = self.uid
                    await userViewModel.addNewUser(uid: self.uid, displayName: self.fullName)
                    isLogin = true
                }
            case .failure(let error):
                Log(error.localizedDescription)
            }
            
        }
        .frame(width: 250, height: 50)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}
