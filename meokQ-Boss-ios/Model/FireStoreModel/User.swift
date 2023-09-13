//
//  User.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/09/12.
//

import Foundation

class User: DocumentTimestamp {
    let uuid = UUID()
    var displayName = ""
    var uid = ""
}


extension User: Hashable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
