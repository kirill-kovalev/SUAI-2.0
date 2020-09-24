//
//  BriefInfo.swift
//  SUAI_API
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SABrief{
    public static let shared = SABrief()
	var briefInfo = Brief(is_sub: false, rockets: Rockets(rockets: 0, top: []), weather: SAWeather(id: 0, conditions: "", temp: 0, temp_min: 0, temp_max: 0), news: [])
    
    public func loadFromServer() -> Bool{
		if let data = PocketAPI.shared.syncLoadTask(method: .getSuper) {
			do{
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .formatted(SADeadline.formatter)
				let decodedData = try decoder.decode(Brief.self, from: data)
				self.briefInfo = decodedData
				UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
				return true
			}catch{print("Brief: \(error)") }
		}else{
			self.loadFromCache()
		}
        return false
    }
	private func loadFromCache(){
		do{
			guard let data = UserDefaults.standard.data(forKey: self.userDefaultsKey) else { return}
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(SADeadline.formatter)
			let decodedData = try decoder.decode(Brief.self, from: data)
			self.briefInfo = decodedData
		}catch{print("Brief: \(error)") }
	}
	private var userDefaultsKey:String {"\(Self.self)Cache"}
	
	
    public var isSub:Bool {self.briefInfo.is_sub}
    public var weather: SAWeather { self.briefInfo.weather}
    public var rockets: SARockets { SARockets(from: self.briefInfo.rockets)}
	public var news : [SAFeedElement] {
		func generateSAFeed(item: VKFeedElement) -> SAFeedElement {
			let title = item.getText().contains("\n") ? String(item.getText().split(separator: "\n").first ?? "") : ""
			let desc = item.getText().contains("\n") ? String(item.getText().split(separator: "\n").last ?? "") : ""
			let url = "https://vk.com/wall\(item.from_id)_\(item.id)"
			
			return SAFeedElement(source: FeedSource(name: "", id: item.owner_id ?? 0), date: item.getDate(), likes: item.getLikes(), comments: item.getComments(), reposts: item.getReposts(), views: item.getViews(), imageURL: item.getPhoto(), title: title, desc: desc, postUrl: url)
		}
		return self.briefInfo.news.map {generateSAFeed(item: $0)}
		
	}
}

public struct SARockets {
    public let top : [SARocketsUser]
    public  let count: Int
    init(from:Rockets) {
        self.top = from.top.map {SARocketsUser(from: $0)}
        self.count = from.rockets
    }
}
public struct SARocketsUser{
    public let id: Int
    public let first_name: String
    public let last_name: String
    public let photo: String
    public let rockets:Int
    init(from:RocketsTop) {
        self.id = from.user.id
        self.first_name = from.user.first_name
        self.last_name = from.user.last_name
        self.photo = from.user.photo_100
        self.rockets = from.rockets
    }
}
