//
//  APIDataTypes.swift
//  SUAI_API
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

// MARK: - Brief
struct Brief:Codable {
    public let is_sub: Bool
    public let rockets: Rockets
    public let weather: SAWeather
	public let news: [VKFeedElement]
}
// MARK: - Weather
public struct SAWeather:Codable {
    public let id: Int
    public let conditions: String
    public let temp: Float
    public let temp_min: Float
    public let temp_max: Float
}
// MARK: - Rockets
struct Rockets:Codable {
    let rockets: Int
    let top: [RocketsTop]
}
// MARK: - RocketsTop
struct RocketsTop:Codable {
    let user: VKUser
    let rockets: Int
}
// MARK: - VKUser
struct VKUser:Codable {
    let id: Int
    let first_name: String
    let last_name: String
    let is_closed: Bool
    let can_access_closed: Bool
    let photo_100: String
}
