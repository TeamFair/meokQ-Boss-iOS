//
//  StatisticsSubmitFinishedTabView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

//TODO: 우측 상단에 노란색 라벨을 붙이지 못하였습니다. 이와 맞는 날짜 및 UI가 필요할 것 같습니다.


import SwiftUI

struct StatisticsSubmitFinishedTabView: View {
    let couponList: [Coupon]
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
            ForEach(couponList, id:\.couponId) { coupon in
                StatisticsComponent(time: dateToString(date: coupon.issuedTimestamp), userName: coupon.userDisplayName, couponName: coupon.reward, questName: coupon.missionDescription)
                    .padding(.horizontal, 16)
            }
        }
        .navigationBarTitle("고객 통계", displayMode: .large)
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E)"

        let dateString = dateFormatter.string(from: date)
        return "\(dateString) 발급완료"
    }
}

struct StatisticsSubmitFinishedTabView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsSubmitFinishedTabView(couponList: [Coupon()])
    }
}
