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
	var briefInfo = Brief(is_sub: false, rockets: Rockets(rockets: 0, top: []), weather: SAWeather(id: 0, conditions: "", temp: 0, temp_min: 0, temp_max: 0), news: [], events: [])
    
    public func loadFromServer() -> Bool{
		if let data = PocketAPI.shared.syncLoadTask(method: .getSuper) {
			do{
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .formatted(SADeadline.formatter)
				let decodedData = try decoder.decode(Brief.self, from: data)
				self.briefInfo = decodedData
				self.briefInfo.saNews = decodeNews( from: self.briefInfo.news)
				self.briefInfo.saEvents = decodeNews( from: self.briefInfo.events)
				self.saveToCache()
				return true
			}catch{print("Brief: \(error)") }
		}
		
		self.loadFromCache()
		
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
	public var events : [SAFeedElement] {
		(self.briefInfo.saEvents ?? []).map { (post) in
			var event = post
			let text = "\n\n" + post.text + "\n\n"
			let tag = eventsParse(text, pattern: "Метка: (.*?)\n") ?? "Метка: "
			let eventTag = String(tag.dropFirst("Метка: ".count))
			event.source = FeedSource(name: eventTag, id: 0)
			event.text = eventsParse(text, pattern: "Название: (.*?)\n") ?? ""
			event.postUrl = eventsParse(text, pattern: "Ссылка: (.*?)\n") ?? ""
			event.date = eventsGetDate(eventsParse(text, pattern: "Время: (.*?)\n") ?? "") ?? Date().addingTimeInterval(-3600*24*10)
			return event
		}
		
	}
	private func eventsGetDate(_ from:String) -> Date?{
		
		let df = DateFormatter()
		df.locale = Locale(identifier: "ru")
		
		df.dateFormat = "d MMMM в HH:mm"
		if let date =  df.date(from: from){ return date }
		
		df.dateFormat = "d MMMM HH:mm"
		if let date =  df.date(from: from){ return date }

		if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.allSystemTypes.rawValue),
		   let date = detector.firstMatch(in: from, options: [.withTransparentBounds], range: NSRange(location: 0, length: from.count))?.date
		{ return date }
		
		return nil
	}
	
	private func eventsParse(_ text:String, pattern:String)->String?{
		let range = NSRange(location: 0,length: text.count)
		if let regexp = try? NSRegularExpression(pattern: pattern, options: []),
			let range = regexp.firstMatch(in: text, options: [], range: range)?.range{
			let foundString = String(text[Range(range, in: text)!])
			return regexp.stringByReplacingMatches(in: foundString, options: [], range: NSRange(location: 0, length: foundString.count), withTemplate: "$1")
		}
		return nil
	}
	
	private func decodeNews(from:[VKFeedElement]) -> [SAFeedElement]{
		return from.map { item in
			SAFeedElement.fromVK(item)
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
