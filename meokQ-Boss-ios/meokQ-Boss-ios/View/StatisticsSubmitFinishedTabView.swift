//
//  StatisticsSubmitFinishedTabView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

//TODO: 우측 상단에 노란색 라벨을 붙이지 못하였습니다. 이와 맞는 날짜 및 UI가 필요할 것 같습니다.


import SwiftUI

struct StatisticsSubmitFinishedTabView: View {
    
    var submitFinishedCouponArray = ["오후 2시전 아메리카노 2잔 주문", "오후 2시전 아메리카노 2잔 주문"]
    var submitFinishedQuestArray = ["아메리카노 50% 할인권", "아메리카노 50% 할인권"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
            ForEach(0..<submitFinishedQuestArray.count) { i in
                StatisticsComponent(couponName: submitFinishedCouponArray[i], questName: submitFinishedQuestArray[i])
                    .padding(.horizontal, 16)
            }
        }
        .navigationBarTitle("고객 통계", displayMode: .large)
    }
}

struct StatisticsSubmitFinishedTabView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsSubmitFinishedTabView()
    }
}
