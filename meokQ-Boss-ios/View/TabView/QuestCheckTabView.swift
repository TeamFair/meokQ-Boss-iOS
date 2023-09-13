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
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                
                ForEach(missionList, id: \.self) { mission in
                    QuestComponent(couponName: mission.reward, questName: mission.missionDescription)
                        .padding(.horizontal, 16)
                }
            }
            .navigationBarTitle("퀘스트", displayMode: .large)
    }
}

struct QuestCheckTabView_Previews: PreviewProvider {
    static var previews: some View {
        QuestCheckTabView(missionList: [])
    }
}
