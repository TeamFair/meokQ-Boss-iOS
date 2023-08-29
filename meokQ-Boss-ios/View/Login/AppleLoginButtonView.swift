//
//  AppleLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices


struct AppleLoginButtonView : View{
    @State var loginData = LoginViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View{
        SignInWithAppleButton { (request) in
                                loginData.nonce = randomNonceString()
                                request.requestedScopes = [.email, .fullName]
                                request.nonce = sha256(loginData.nonce)
        } onCompletion: { (result) in
            switch result {
            case .success(let user):
                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                    print("error with firebase")
                    return
                }
                
                loginData.authenticate(credential: credential) { uid in
                    appState.uid = uid
                    appState.isLogin = true
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .frame(width: 250, height: 50)
        .cornerRadius(5)
    }
}


class LoginViewModel: ObservableObject {
    @Published var nonce = ""
    
    func authenticate(credential: ASAuthorizationAppleIDCredential, completion: @escaping (String?) -> Void) {
        //getting token
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        Auth.auth().signIn(with: firebaseCredential) { result, err in
            if let err = err {
                print(err.localizedDescription)
            }
            
            if let uid = result?.user.uid {
                DispatchQueue.main.async {
                    completion(uid) // Pass the uid to the completion handler
                }
            } else {
                completion(nil) // Pass nil if uid is not available
            }

            print("로그인 완료")
        }
    }
}

// Helper for Apple Login with Firebase
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
