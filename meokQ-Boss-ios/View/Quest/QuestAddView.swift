//
//  QuestAddView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI

// 퀘스트 추가 시 나오는 화면입니다.
//TODO: 제출하기 클릭 후 확인 또는 취소 누를 시 dismiss가 되는 현상

struct QuestAddView: View {
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var questTextValue: String = ""
    @State private var prizeTextValue: String = ""
    @State private var alertMessage: Bool = false
    @StateObject private var marketStore = MarketStore()
    @EnvironmentObject var appState: AppState
    var body: some View {
        
        ZStack{
            VStack{
                HStack{
                    Spacer()
                    Text("남은 퀘스트 개수 : \(marketStore.market.missionCount)개")
                        .font(Font.custom("Pretendard", size: 15)
                            .weight(.regular))
                        .padding(.trailing, 16)
                }
                .padding(.top, 50)
                
                HStack{
                    Text("퀘스트")
                        .font(Font.custom("Pretendard", size: 25)
                            .weight(.semibold))
                        .padding(.leading, 16)
                    Spacer()
                }
                
                TextField("퀘스트를 입력하세요", text: $questTextValue)
                    .font(Font.custom("Pretendard", size: 14)
                        .weight(.medium))
                    .frame(minHeight: 80)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(hue: 0, saturation: 0, brightness: 0.96))
                    .cornerRadius(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke()
                    }
                    .padding(.horizontal, 16)
                
        //보상란
                HStack{
                    Text("보상")
                        .font(Font.custom("Pretendard", size: 25)
                            .weight(.semibold))
                        .padding(.leading, 16)
                    Spacer()
                }
                
                TextField("보상을 입력하세요", text: $prizeTextValue)
                    .font(Font.custom("Pretendard", size: 14)
                        .weight(.medium))
                    .frame(minHeight: 80)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(hue: 0, saturation: 0, brightness: 0.96))
                    .cornerRadius(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke()
                    }
                    .padding(.horizontal, 16)
                
                
                Spacer()
                
                HStack{
                    Button {
                        alertMessage = true
                    } label: {
                        Text("제출하기")
                            .padding(.vertical, 20)
                            .font(Font.custom("Pretendard", size: 20)
                                .weight(.semibold))
                            .foregroundColor(Color.black)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.Yellow)
                    .alert(isPresented: $alertMessage) {
                        Alert(title: Text("퀘스트를 추가하시겠습니까?"), message: Text("추가 후 수정이 제한되니 유의 부탁드립니다"),
                              primaryButton:  .default(Text("확인") ,action: {
                            Task {
                                await marketStore.addMission(marketId: uid, missionDescription: questTextValue, reward: prizeTextValue, missionCount: marketStore.market.missionCount)
                                await marketStore.fetchMarket(marketId: uid)
                            }
                        }),
                              secondaryButton:.cancel(Text("취소")))
                    }
                }
                .cornerRadius(20)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                
                
                
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.black)
                    }

                }
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("퀘스트 추가")
                        }
                    }
            }
        }
        .background(Color.LightYellow)
        .task {
            await marketStore.fetchMarket(marketId: uid)
        }
    }
}

struct QuestAddView_Previews: PreviewProvider {
    static var previews: some View {
        QuestAddView()
            .environmentObject(AppState(uid: "marketIdSample1"))
    }
}
