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
    @AppStorage("uid") var uid: String = ""
    @AppStorage("userName") var userName: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    @Namespace var namespace
    
    @Binding var viewTitle: String
    @State private var selectedSection = QuestTitleSection.posting
    @ObservedObject var marketStore: MarketStore
    @EnvironmentObject var appState: AppState
    
    let sectionList: [QuestTitleSection] = [.posting, .checking]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
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
                            QuestPostTabView(missionList: marketStore.missions.values.filter { $0.status == "approved" })
                        } else {
                            QuestCheckTabView(missionList: marketStore.missions.values.filter { $0.status == "pending" })
                        }
                    }
                }
                .padding(.top, 10)
                Spacer()
                NavigationLink(destination: QuestAddView().environmentObject(appState)) {
                    Text("퀘스트 추가하기")
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(.yellow)
                        .font(Font.custom("Pretendard", size: 20).weight(.semibold))
                }
            }
        }
        .background(Color.LightYellow)
        .task {
            viewTitle = "퀘스트"
            await marketStore.fetchAllMarketMissions(marketId: uid)
        }
    }
}

struct QuestView_Previews: PreviewProvider {
    static var previews: some View {
        QuestView(viewTitle: .constant("퀘스트"), marketStore: MarketStore())
            .environmentObject(AppState(uid: "marketIdSample1"))
    }
}


