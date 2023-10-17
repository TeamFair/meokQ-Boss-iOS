//
//  QuestCheckView.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/18.
//

import SwiftUI

struct QuestCheckTabView: View {
    let missionList: [Mission]
    var body: some View {
        if missionList.isEmpty {
            Text("현재 검토중인 퀘스트가 없습니다")
                .padding(.top, 200)
        } else {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                ForEach(missionList.sorted(by: {$0.createdTimestamp > $1.createdTimestamp}), id: \.self) { mission in
                    QuestComponent(couponName: mission.reward, questName: mission.missionDescription)
                        .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct QuestCheckTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestCheckTabView(missionList: [])
    }
}
