//
//  QuestCheckView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI

struct QuestCheckTabView: View {
    
    var questCheckNameArray = ["오후 2시전 아메리카노 2잔 주문", "오후 2시전 아메리카노 2잔 주문"]
    var couponCheckNameArray = ["아메리카노 50% 할인권", "아메리카노 50% 할인권"]
    
    var body: some View {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                
                ForEach(0..<questCheckNameArray.count) { i in
                    QuestComponent(couponName: couponCheckNameArray[i], questName: questCheckNameArray[i])
                        .padding(.horizontal, 16)
                }
            }
            .navigationBarTitle("퀘스트", displayMode: .large)
    }
}

struct QuestCheckTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestCheckTabView()
    }
}
