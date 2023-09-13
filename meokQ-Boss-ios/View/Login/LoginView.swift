//
//  LoginView.swift
//  TeamFair
//
//  Created by 077tech on 2023/07/01.
//

import SwiftUI
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import KakaoSDKUser
import KakaoSDKAuth
import _AuthenticationServices_SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @StateObject var marketStore = MarketStore()
    @EnvironmentObject var userStore: UserStore
    
    var kakaoButtonAction: () -> Void {
        {
            kakaoAuthSignIn()
        }
    }
    
    var googleButtonAction: () -> Void {
        {
            googleSigninButtonAction()
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.LightYellow
                .ignoresSafeArea()
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top, 50)
                Text("맛Q")
                    .font(.system(size: 50).weight(.bold))
                    .foregroundColor(.Yellow)
                    .padding(.bottom, 150)
                VStack(spacing: 27) {
                    KakaoLoginButtonView(buttonAction: kakaoButtonAction)
                    GoogleLoginButtonView(buttonAction: googleButtonAction)
                    AppleLoginButtonView()
                        .environmentObject(userStore)
                        .environmentObject(appState)
                }
                .padding(.bottom, 100)
                NavigationLink(
                    destination: TabbarView()
                        .environmentObject(appState)
                        .environmentObject(marketStore)
                        .environmentObject(userStore)
                ) {
                    Text("로그인 없이 둘러보기")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .underline()
                }
                NavigationLink(destination: TabbarView()
                    .environmentObject(appState), isActive: $isLogin) {
                        EmptyView()
                    }
            }
        }
        .navigationBarBackButtonHidden()
        .accentColor(.black)
        .id(appState.roginViewId)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension LoginView {
    // 상태 체크
    func googleSigninButtonAction() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // 로그아웃 상태
                Log("Not Sign In")
                googleSignInFireAuthSignup()
            } else {
                // 로그인 상태
                guard let profile = user?.profile else { return }
                isLogin = true
            }
        }
    }
    // 구글 로그인
    func googleSignInFireAuthSignup() {
        
        Log("Google googleLogin()")
        // rootViewController
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        // 로그인 진행
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            guard let result = signInResult else {
                Log("Google googleLogin() result gaurd")
                return
            }
            guard error == nil else {
                Log("Google googleLogin() err gaurd")
                return
            }
            guard let profile = result.user.profile else {
                Log("Google googleLogin() profile gaurd")
                return
            }
            Log(profile.email)
            Log(profile.name)
            
            let user = result.user
            guard let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                
                if let err = error {
                    Log(err)
                    return
                }
                // At this point, our user is signed in
                Log("Google : \(result?.description ?? "")")
                Log("Google : \(result?.user.providerID ?? "")")
                Log("Google : \(result?.user.uid ?? "")")
                if let resultuid = result?.user.uid {
                    self.uid = resultuid
                    self.userName = profile.name
                    Task {
                        appState.uid = resultuid
                        await userStore.addNewUser(uid: resultuid, displayName: userName)
                        isLogin = true
                    }
                    
                }
            }
        }
    }
}


// MARK: - Kakao 로그인
extension LoginView {
    func emailAuthSignUp(email: String, userName: String, password: String, completion: (() -> Void)?) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                Log("error: \(error.localizedDescription)")
            }
            if result != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                Log("다음 사용자 이메일: \(String(describing: result?.user.email ?? ""))")
                Log("다음 사용자 uid : \(result?.user.uid ?? "")")
                self.uid = result?.user.uid ?? ""
                Task {
                    appState.uid = self.uid
                    await userStore.addNewUser(uid: self.uid, displayName: userName)
                    isLogin = true
                }
                
            }
            
            completion?()
        }
    }
    
    func kakaoAuthSignIn() {
        if AuthApi.hasToken() { // 발급된 토큰이 있는지
            UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
                if let error = error { // 에러가 발생했으면 토큰이 유효하지 않다.
                    self.openKakaoService()
                } else { // 유효한 토큰
                    self.loadingInfoDidKakaoAuth()
                }
            }
        } else { // 만료된 토큰
            self.openKakaoService()
        }
    }
    
    func openKakaoService() {
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
                if let error = error { // 로그인 실패 -> 종료
                    Log("Kakao Sign In Error: \(error.localizedDescription)")
                    return
                }
                
                _ = oauthToken // 로그인 성공
                Log("accessToken : \(oauthToken?.accessToken ?? "")")
                Log("refreshToken : \(oauthToken?.refreshToken ?? "")")
                Log("idToken : \(oauthToken?.idToken ?? "")")
                
                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        }
    }
    
    func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
        UserApi.shared.me { kakaoUser, error in
            if let error = error {
                Log("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                return
            }
            guard let email = kakaoUser?.kakaoAccount?.email else { return }
            guard let password = kakaoUser?.id else { return }
            guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
            
            self.emailAuthSignUp(email: email, userName: userName, password: "\(password)") {
                self.userName = userName
                Log("사용자 이름: \(userName)")
                self.emailAuthSignIn(email: email, password: "\(password)")
            }
        }
    }
    
    func emailAuthSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                Log("error: \(error.localizedDescription)")
                return
            }
            
            if result != nil {
                Log("사용자 이메일: \(String(describing: result?.user.email ?? ""))")
                Log("사용자 uid : \(result?.user.uid ?? "")")
                self.uid = result?.user.uid ?? ""
                isLogin = true
            }
        }
    }
    
}
