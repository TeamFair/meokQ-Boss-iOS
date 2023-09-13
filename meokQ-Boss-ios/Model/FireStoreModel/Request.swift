//
//  Request.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation


class Request: DocumentTimestamp {
    let uuid = UUID()
    var marketId = ""
    var message = ""
    var missionId = ""
    var requestId = ""
    var missionVerificationRequestImage = ""
    var status = ""
    var userId = ""
    var reward = ""
    var missionDescription = ""
}


extension Request: Hashable {
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        lhs.missionId == rhs.missionId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(missionId)
    }
}
