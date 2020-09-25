//
//  BriefInfo.swift
//  SUAI_API
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import SwiftyVK

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
				self.briefInfo.saNews = decodeNews( from: self.briefInfo.news)
				self.saveToCache()
				return true
			}catch{print("Brief: \(error)") }
		}else{
			self.loadFromCache()
		}
        return false
    }
	private func saveToCache(){
		if let data = try? JSONEncoder().encode(self.briefInfo){
			UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
		}
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
	public var news : [SAFeedElement] {self.briefInfo.saNews ?? [] }
	
	
	private func decodeNews(from:[VKFeedElement]) -> [SAFeedElement]{
		let sources:[FeedSource] = [
			FeedSource(name: "ГУАП" , id: -122496494),
			FeedSource(name: "Профком" , id: -232453),
			FeedSource(name: "Медиа" , id: -5515524),
			FeedSource(name: "Спорт" , id: -138336798),
			FeedSource(name: "Музгуап" , id: -66449391),
			FeedSource(name: "Гараж" , id: -149885408),
			FeedSource(name: "КВН" , id: -9187),
		]
		return from.map { item in
			let title = item.getText().contains("\n") ? String(item.getText().split(separator: "\n").first ?? "") : ""
			let desc = item.getText().contains("\n") ? String(item.getText().split(separator: "\n").last ?? "") : ""
			let url = "https://vk.com/wall\(item.from_id)_\(item.id)"
			
			var element = SAFeedElement(source: FeedSource(name: "", id: item.owner_id ?? 0) , date: item.getDate(), likes: item.getLikes(), comments: item.getComments(), reposts: item.getReposts(), views: item.getViews(), imageURL: item.getPhoto(), title: title, desc: desc, postUrl: url)
			
			if let source = sources.filter({ abs($0.id) == abs(item.owner_id ?? 0 )}).first {
				element.source = source
				return element
			}
			do{
				struct VKGetNameResponse:Codable{var name:String}
				let resp = try VK.API.Groups.getById([.groupIds:"\(abs(item.owner_id ?? 0 ))"]).synchronously().send() ?? Data()
				let decoded = try JSONDecoder().decode([VKGetNameResponse].self, from: resp).first
				
				element.source = FeedSource(name: decoded?.name ?? "", id: item.owner_id ?? 0)
			}catch{
				print(error)
			}
			return element
			
			
		}
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
