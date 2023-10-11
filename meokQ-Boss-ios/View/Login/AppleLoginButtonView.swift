//
//  AppleLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct AppleLoginButtonView: View {
    @Binding var selectedTab: Int
    
    @EnvironmentObject var userViewModel: UserStore
    @StateObject var appleLoginViewModel = AppleLoginViewModel()
    
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @State var fullName = ""
    
    var body: some View {
        ZStack {
            Color.black
            HStack {
                Image(LoginButton.apple.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                Spacer()
                Text(LoginButton.apple.labelText)
                    .foregroundColor(LoginButton.apple.accentColor)
                //                        .font(.system(size: 14).weight(.medium))
                    .font(.custom("SFProDisplay-Medium", size: 14))
                Spacer()
            }
            .padding(.horizontal, 12)
        }
        .frame(width: 250, height: 50)
        .overlay {
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
                        await userViewModel.addNewUser(uid: self.uid, displayName: self.fullName)
                        isLogin = true
                        selectedTab = 3
                    }
                case .failure(let error):
                    Log(error.localizedDescription)
                }
                
            }
            .blendMode(.overlay)
        }
        .clipped()
    }
}
