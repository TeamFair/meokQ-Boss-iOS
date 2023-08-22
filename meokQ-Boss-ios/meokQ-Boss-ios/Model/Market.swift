//
//  Market.swift
//  meokQ-Boss-ios
//
//  Created by apple on 2023/08/19.
//

import Foundation

struct Market: Codable {
    let address: String
    let couponHistorys: [String: Coupon]
    let marketImage: String
    let marketName: String
    let missions: [String: Mission]
    let openingHours: String
    let tel: String
}

struct Coupon: Codable {
    let content: String
    let status: Int
    let userId: String
    let userName: String
}

struct Mission: Codable {
    let content: String
    let date: String
    let reward: String
}

struct UserInfo: Codable {
    let name: String
    let status: String
}

struct RequestCoupon: Codable {
    let imagePath: String
    let requestId: String
    let userId: String
    let username: String
}
