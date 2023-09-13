//
//  StatisticsComponent.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI

struct StatisticsComponent: View {
    
    let time: String
    let userName: String
    var couponName: String
    var questName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text(time)
                    .font(Font.custom("Pretendard", size: 10))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.yellow)
                    )
            }
            Text(couponName)
                .font(Font.custom("Pretendard", size: 23)
                    .weight(.medium))
            Text(questName)
                .font(Font.custom("Pretendard", size: 14)
                    .weight(.regular))
                .foregroundColor(.gray)
            HStack {
                Spacer()
                Text(userName)
                    .font(Font.custom("Pretendard", size: 12)
                        .weight(.medium))
                    .foregroundColor(Color.gray)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

struct StatisticsComponent_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsComponent(time: "7/8(토)", userName: "0oasdf00", couponName: "ㅇoooooooooasdfasdfasdfㅇㅇ", questName: "ㅇㅇㅇㅇㅇ").padding(.vertical, 20).background(.brown)
    }
}
