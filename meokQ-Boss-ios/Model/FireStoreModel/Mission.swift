//
//  Mission.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/30.
//

import Foundation

class Mission: DocumentTimestamp {
    let uuid = UUID()
    var status = ""
    var missionDescription = ""
    var missionId = ""
    var reward = ""
    var paidStatus = true
}


extension Mission: Hashable {
    
    static func == (lhs: Mission, rhs: Mission) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
