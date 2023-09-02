//
//  QuestView.swift
//  meokQ-Boss-ios
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI

// "퀘스트"를 상단에 표현하였고 상단 Tabbar를 사용해서 QuestPostTabView와 QuestCheckTabView를 표현합니다.
//TODO: 퀘스트 추가하기 버튼 필요

struct QuestView: View {
    @Namespace var namespace
    @State private var selectedSection = QuestTitleSection.posting
    @StateObject var marketStore = MarketStore()
    @EnvironmentObject var appState: AppState
    
    let sectionList: [QuestTitleSection] = [.posting, .checking]

    var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            HStack{
                                Text("퀘스트")
                                    .font(Font.custom("Pretendard", size: 34)
                                        .weight(.bold))
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.top, 23)
                            
                            HStack(spacing: 30) {
                                ForEach(sectionList, id: \.self) { section in
                                    QuestTitleTextView(section: section, namespace: namespace, selectedSection: $selectedSection)
                                        .onTapGesture {
                                            withAnimation(.easeOut) {
                                                selectedSection = section
                                            }
                                        }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 1)
                                    .foregroundColor(.gray)
                                    .offset(y: 18)
                            }
                            
                            if selectedSection == .posting {
                                QuestPostTabView(missionList: marketStore.missions.filter { $0.status == "approved" })
                            } else {
                                QuestCheckTabView(missionList: marketStore.missions.filter { $0.status == "pending" })
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.top, 10)
                    Spacer()
                        NavigationLink(destination: QuestAddView()) {
                            Text("퀘스트 추가하기")
                                .font(Font.custom("Pretendard", size: 20)
                                    .weight(.semibold))
                        }
                }
            }
            .background(Color.LightYellow)
            .task {
                if let marketId = appState.uid {
                    await marketStore.fetchAllMarketMissions(marketId: marketId)
                }
            }
    }
}

struct QuestView_Previews: PreviewProvider {
    static var previews: some View {
        QuestView()
            .environmentObject(AppState(uid: "marketIdSample1"))
    }
}


