//
//  QuestPostTabView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI
import Firebase

struct QuestPostTabView: View {
    let missionList: [Mission]
    
    var body: some View {
        if missionList.isEmpty {
            Text("현재 게시중인 퀘스트가 없습니다")
                .padding(.top, 200)
        } else {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                ForEach(missionList, id: \.self) { mission in
                    QuestComponent(couponName: mission.reward, questName: mission.missionDescription)
                        .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct QuestPostTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestPostTabView(missionList: [])
    }
}
