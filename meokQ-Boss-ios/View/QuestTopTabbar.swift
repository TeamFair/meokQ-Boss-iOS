//
//  QuestTopTabber.swift
//  BossTestUI
//
//  Created by 077tech on 2023/08/19.
//

import Foundation
import SwiftUI

//QuestView 상단에 Tabbar 입니다. 게시중과 검토중을 표현합니다.

enum QuestTitleSection: String {
    case posting, checking
    
    var rawValue: String {
        switch self {
        case .posting:
            return "게시중"
        case .checking:
            return "검토중"
        }
    }
}

struct QuestTitleTextView: View {
    let section: QuestTitleSection
    let namespace: Namespace.ID
    @Binding var selectedSection: QuestTitleSection
    
    var body: some View {
        Text(section.rawValue)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(section == selectedSection ? .black : .gray)
            .padding(.horizontal, 20)
            .background(
                ZStack {
                    if section == selectedSection {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 2)
                            .offset(y: 18)
                            .matchedGeometryEffect(id: "DetailSectionCard", in: namespace)
                    }
                }
            )
            .padding()
    }
}
