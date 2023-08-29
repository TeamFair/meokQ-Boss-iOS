//
//  StatisticsComponent.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI

struct StatisticsComponent: View {
    
    @State var userName : String = "chad0909"
    
    
    var couponName: String
    var questName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(couponName)
                .font(Font.custom("Pretendard", size: 23)
                    .weight(.medium))
            Text(questName)
                .font(Font.custom("Pretendard", size: 14)
                    .weight(.regular))
            HStack {
                Spacer()
                Text("chad0909")
                    .font(Font.custom("Pretendard", size: 12)
                        .weight(.medium))
                    .foregroundColor(Color.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .background(.white)
        .cornerRadius(16)
    }
}

struct StatisticsComponent_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsComponent(couponName: "ㅇㅇㅇ", questName: "ㅇㅇㅇㅇㅇ").padding(.vertical, 20).background(.brown)
    }
}
