//
//  SignoutView.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/14.
//

import SwiftUI
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

struct SignoutView: View {
    
    @State private var isChecked = false
    
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @State private var delAlert = false
    
    @EnvironmentObject var userViewModel: UserStore
    var body: some View {
        VStack(alignment: .center){
            
            Spacer().frame(height: 30).listRowBackground(Color.clear)
            
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipped()
            
            Text("맛Q 탈퇴 전 확인하세요")
            .font(Font.custom("Pretendard", size: 22))
            .underline()
            .foregroundColor(Color(red: 0.18, green: 0.18, blue: 0.18))
            
            Text("탈퇴하시면 모든 데이터는 복구가 불가능합니다.")
            .font(Font.custom("Pretendard", size: 16))
            .foregroundColor(Color(red: 0.18, green: 0.18, blue: 0.18))
            
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 320, height: 70)
                    .background(.white)
                
                Text("• 진행 및 완료된 모든 퀘스트 내용이 삭제됩니다.\n\n• 사장님이 관 리하는 단골 데이터에서 삭제됩니다.")
                    .font(Font.custom("Pretendard", size: 12))
                
            }
            Spacer()
                .frame(height: 28)
            
            HStack{
                Button {
                    print("pushed")
                    isChecked.toggle()
                } label: {
                    if isChecked == true{
                        Image(systemName: "checkmark.square")
                            .resizable()
                            .colorMultiply(.black)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .clipped()
                    }else {
                        Image(systemName: "square")
                            .resizable()
                            .colorMultiply(.black)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .clipped()
                    }
                }
                Text("안내사항을 모두 확인하였으며, 이에 동의합니다.")
                    .font(Font.custom("Pretendard", size: 12))
                    .foregroundColor(Color(red: 0.18, green: 0.18, blue: 0.18))
                
            }
            
            Spacer()
                .frame(height: 75)
            
            Button {
                print("pushed")
                delAlert.toggle()
            } label: {
                Text("탈퇴하기")
                .font(
                Font.custom("Pretendard", size: 18)
                .weight(.medium)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            }
            .disabled(!isChecked)
            .alert(isPresented: $delAlert) {
                Alert(
                    title: Text("회원탈퇴를 하시겠습니까?"),
                    message: Text("회원탈퇴를 하게 된다면 모든 데이터는 복구가 불가능합니다."),
                    primaryButton: .destructive(Text("확인"),action: {
                        print("유저 정보 \(uid),\(userName),\(isLogin)")
                        UserStore().deleteDataFromFirestore(uid: uid) {
                            print("del")
                            uid = ""
                            userName = ""
                            isLogin = false
                            
                            Log("Google googleLogin()")
                            // rootViewController
                            guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
                            // 로그인 진행
                            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                            // Create Google Sign In configuration object.
                            let config = GIDConfiguration(clientID: clientID)
                            GIDSignIn.sharedInstance.configuration = config
                            
                            GIDSignIn.sharedInstance.signOut()
                            GIDSignIn.sharedInstance.disconnect()
                            
                        }
                        
                        print("유저 정보 \(uid),\(userName),\(isLogin)")
                    }),
                    secondaryButton: .cancel(Text("취소"))
                )
            }
            .frame(width: 180, height: 40, alignment: .center)
            .background(isChecked ? Color(red: 0.76, green: 0.29, blue: 0.29) : (Color(red: 0.4, green: 0.4, blue: 0.4)))
                .cornerRadius(7.66667)
                .shadow(color: .black.opacity(0.16), radius: 5, x: 0, y: 0)
            
            Spacer()

        }
        .frame(maxWidth: .infinity)
        .navigationTitle("회원탈퇴")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.LightYellow)
    }
}

struct SignOutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignoutView()
        }
    }
}
