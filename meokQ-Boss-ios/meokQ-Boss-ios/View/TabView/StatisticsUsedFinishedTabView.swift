//
//  StatisticsUsedFinishedTabView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

//TODO: 우측 상단에 노란색 라벨을 붙이지 못하였습니다. 이와 맞는 날짜 및 UI가 필요할 것 같습니다.


import SwiftUI

struct StatisticsUsedFinishedTabView: View {
    var usedFinishedCouponArray = ["오후 2시전 아메리카노 2잔 주문", "오후 3시전 아메리카노 3잔 주문"]
    var usedFinishedQuestArray = ["아메리카노 50% 할인권", "아메리카노 60% 할인권"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
            
            ForEach(0..<usedFinishedCouponArray.count) { i in
                StatisticsComponent(couponName: usedFinishedCouponArray[i], questName: usedFinishedQuestArray[i])
                    .padding(.horizontal, 16)
            }
        }
    }
}

struct StatisticsUsedFinishedTabView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsUsedFinishedTabView()
    }
}
