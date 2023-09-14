//
//  SettingView.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/14.
//

import SwiftUI
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

struct SettingView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @State private var logOut = false
    
    let settingList: [Setting] = [
        Setting(title: "로그아웃", type: .LogOut),
        Setting(title: "회원탈퇴", type: .Quit)
    ]

    var body: some View {
        VStack{
            Spacer().frame(height: 10).listRowBackground(Color.clear)
            List {
                ForEach(settingList, id: \.title) { head in
                    switch head.type {
                    case .LogOut:
                        Button(action: {
                            appState.loginViewId = UUID()
                            logOut.toggle()
                        }) {
                            
                            HStack {
                                Text(head.title)
                                    .foregroundColor(.red)
                                    .font(.system(size: 16).weight(.medium))
                            }
                        }
                        .alert(isPresented: $logOut) {
                            Alert(
                                title: Text("로그아웃 하시겠습니까?"),
                                primaryButton: .destructive(Text("확인"),action: {
                                    //MARK: 로그아웃 기능 함수 추가 요청
                                    print("Pushed")
                                    print("유저 정보 \(uid),\(userName),\(isLogin)")
                                    
                                    GIDSignIn.sharedInstance.signOut()
                                    GIDSignIn.sharedInstance.disconnect()
                                    
                                    uid = ""
                                    userName = ""
                                    isLogin = false
                                    print("유저 정보 \(uid),\(userName),\(isLogin)")
                                }),
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.clear)
                    case .Quit:
                        NavigationLink(destination: SignoutView()) {
                            Text(head.title)
                                .foregroundColor(.red)
                                .font(.system(size: 16).weight(.medium))
                        }
                        .environmentObject(appState)
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("설정")
        }
        .background(Color.LightYellow)
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingView()
                .environmentObject(AppState())
        }
    }
}
