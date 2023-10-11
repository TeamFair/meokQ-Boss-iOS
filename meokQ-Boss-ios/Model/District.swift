//
//  District.swift
//  meokQ-Boss-ios
//
//  Created by apple on 10/10/23.
//

import Foundation

enum City: String {
    case 서울시
    case 기타지역
}

enum District: String, CaseIterable, Hashable {
    case 강남구
    case 서초구
    case 마포구
    case 송파구
    case 중구
    case 영등포구
    case 금천구
    case 구로구
    case 서대문구
    case 기타지역
    
    var districtCode: String {
        switch self {
        case .강남구:
            return "1168000000"
        case .서초구:
            return "1165000000"
        case .마포구:
            return "1144000000"
        case .송파구:
            return "1171000000"
        case .중구:
            return "1114000000"
        case .영등포구:
            return "1156000000"
        case .금천구:
            return "1154500000"
        case .구로구:
            return "1153000000"
        case .서대문구:
            return "1141000000"
        case .기타지역:
            return "0000000000"
        }
    }
}

struct Region {
    static let cities: [City: [District]] = [
        .서울시: [.강남구, .서초구, .마포구, .송파구, .중구, .영등포구, .금천구, .구로구, .서대문구],
        .기타지역: []
    ]
    
    static var cityKeys: [City] {
        cities.map({$0.key})
    }
}


