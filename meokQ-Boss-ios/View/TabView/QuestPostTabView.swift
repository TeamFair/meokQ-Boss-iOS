//
//  QuestPostTabView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI

struct QuestPostTabView: View {
    
    var questPostNameArray = ["오후 2시전 아메리카노 2잔 주문", "오후 3시전 아메리카노 2잔 주문", "오후 4시전 아메리카노 2잔 주문"]
    var couponPostNameArray = ["아메리카노 50% 할인권", "아메리카노 60% 할인권", "아메리카노 70% 할인권"]
    
    var body: some View {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                ForEach(0..<questPostNameArray.count) { i in
                    QuestComponent(couponName: couponPostNameArray[i], questName: questPostNameArray[i])
                        .padding(.horizontal, 16)
                }
            }
        
    }
}

struct QuestPostTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestPostTabView()
    }
}
