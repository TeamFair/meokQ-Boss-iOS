//
//  StatisticsView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI
// 위에 고객 통계를 표시하고 발급완료와 사용완료 tab을 표시합니다. 아래는 StatisticsSubmitFinishedTabView와 StatisticsUsedFinishedTabView를 표현합니다


struct StatisticsView: View {
    @State private var selectedTab = 0
    @Namespace var namespace
    @State private var selectedSection = StatisticsTitleSection.published
    let sectionList: [StatisticsTitleSection] = [.published, .used]

    @EnvironmentObject var appState: AppState
    @ObservedObject var marketStore: MarketStore
    var body: some View {
            ZStack{
                VStack(spacing: 0){
                    ScrollView{
                        VStack(spacing: 0){
                            HStack{
                                Text("고객 통계")
                                    .font(Font.custom("Pretendard", size: 34)
                                        .weight(.bold))
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.top, 23)
                            
                            HStack(spacing: 30) {
                                ForEach(sectionList, id: \.self) { section in
                                    StatisticsTitleTextView(section: section, namespace: namespace, selectedSection: $selectedSection)
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
                            if selectedSection == .published {
                                StatisticsSubmitFinishedTabView(couponList: marketStore.coupons.filter{$0.status == "issued"})
                            } else {
                                StatisticsUsedFinishedTabView(couponList: marketStore.coupons.filter{$0.status == "redeemed"})
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.top, 10)
                    Spacer()
                }
            }
            .background(Color.LightYellow)
            .task {
                if let marketId = appState.uid {
                    await marketStore.fetchUser()
                    await marketStore.fetchCouponStatistics(marketId: marketId)
                }
            }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(marketStore: MarketStore())
            .environmentObject(AppState(uid: "marketIdSample2"))
    }
}
