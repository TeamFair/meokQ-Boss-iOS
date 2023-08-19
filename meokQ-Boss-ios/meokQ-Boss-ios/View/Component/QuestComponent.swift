//
//  QuestComponent.swift
//  meokQ-Boss-ios
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI

struct QuestComponent: View {
    var couponName: String
    var questName: String
    var body: some View {
        ZStack
        {
            HStack{
                VStack(alignment: .leading) {
                    Text(couponName)
                        .font(Font.custom("Pretendard", size: 23)
                            .weight(.medium))
                    Text(questName)
                        .font(Font.custom("Pretendard", size: 14)
                            .weight(.regular))
                }
                Spacer()
            }
            
            .padding(.leading, 25)
            .padding(.vertical, 21)
            .background(.white)
            .cornerRadius(16)
        }
       

    }
}

struct QuestComponent_Previews: PreviewProvider {
    static var previews: some View {
        QuestComponent(couponName: "아메리카노 50% 할인권", questName: "오후 2시전 아메리카노 2잔 주문")
    }
}

