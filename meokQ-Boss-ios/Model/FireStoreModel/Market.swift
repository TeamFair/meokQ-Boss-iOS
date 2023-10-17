//
//  Market.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation


class Market: DocumentTimestamp, ObservableObject {
    let uuid = UUID()
    @Published var address = ""
    @Published var businessOwnerId = ""
    @Published var closingTime = ""
    @Published var district = ""
    @Published var marketId = ""
    @Published var marketImages = "https://firebasestorage.googleapis.com/v0/b/teamfair-7fb46.appspot.com/o/defaultImage%2FLogo.png?alt=media&token=3ff92859-7919-49e6-a4ca-173f1635df91&_gl=1*1hlfeu3*_ga*NTc3MzYwNTE5LjE2ODMwOTkyMTg.*_ga_CW55HF8NVT*MTY5NzA3NzUyNi4xNTkuMS4xNjk3MDc3NTI4LjU4LjAuMA.."
    @Published var missionCount = 0
    @Published var name = ""
    @Published var openingTime = ""
    @Published var phoneNumber = ""
}

extension Market: Hashable {
    
    static func == (lhs: Market, rhs: Market) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
