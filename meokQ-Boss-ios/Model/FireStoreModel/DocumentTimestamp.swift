//
//  DocumentTimestamp.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/30.
//

import Foundation
import Firebase

class DocumentTimestamp: Codable {
    var createdTimestamp: Date = Date()
    var modifiedTimestamp: Date = Date()
    
    init(createdTimestamp: Date = Date(), modifiedTimestamp: Date = Date()) {
        self.createdTimestamp = createdTimestamp
        self.modifiedTimestamp = modifiedTimestamp
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdTimestamp = try container.decode(Date.self, forKey: .createdTimestamp)
        self.modifiedTimestamp = try container.decode(Date.self, forKey: .modifiedTimestamp)
    }
}



