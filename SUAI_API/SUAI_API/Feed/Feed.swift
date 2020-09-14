//
//  Feed.swift
//  SUAI_API
//
//  Created by Кирилл on 28.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import SwiftyVK

public class SAFeedStream{
    public static let empty = SAFeedStream()
    public let source:FeedSource
    public var feed:[SAFeedElement] = []
    public var offset:Int = 0
    
    public var count = 7
    
    public func reload(){
        self.offset = 0
        self.feed = []
        let _ = next()
    }
	
	private var userDefaultsKey:String {"\(Self.self)\(self.source)Cache"}
    public func next() -> [SAFeedElement]{
        var new:[SAFeedElement] = []
        
        let data = PocketAPI.shared.syncLoadTask(method: .getFeed, params:[
            "owner_id":self.source.id,
            "count":self.count,
            "offset":self.offset,
        ]) ?? Data()
        do{
            let feed = try JSONDecoder().decode([VKFeedElement].self, from: data)
			for item in feed{
                new.append(generateSAFeed(item: item))
                self.offset += 1
            }
			UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
        }catch{
			let resp = String(data: data, encoding: .utf8)
			print("FeedStream (\(self.source.name)): \(data) \n \n Error: \(error)")
            new = loadStraightFromVK()
        }
		if new.isEmpty && offset < count {
			print("FeedStream VK (\(self.source.name) : from cache")
			new = loadFromCache()
		}
        
        self.feed.append(contentsOf: new)
        return new
    }

    private func loadStraightFromVK() -> [SAFeedElement]{
        do{
            print("loading from VK (\(self.source.name))")
            let v = VK.sessions.default.config.apiVersion
            VK.sessions.default.config.apiVersion = "5.103"
            guard let data = try VK.API.Wall.get([
                .ownerId : "\(self.source.id)",
                .count : "\(self.count)",
                .offset: "\(self.offset)"
            ]).synchronously().send() else{ return []}
            print("loaded from VK (\(self.source.name) - OK")
            VK.sessions.default.config.apiVersion = v
            
            
            struct VKNews:Codable{
                var items:[VKFeedElement]
            }
        
            let feed = try JSONDecoder().decode(VKNews.self, from: data).items
            return feed.map{self.generateSAFeed(item: $0)}
            
        }catch{ print("FeedStream VK : \(error)"); return []}
    }
	
	private func loadFromCache() -> [SAFeedElement]{
		guard let data = UserDefaults.standard.data(forKey: self.userDefaultsKey) else {return []}
		do{
			let feed = try JSONDecoder().decode([VKFeedElement].self, from: data)
			return feed.map{generateSAFeed(item: $0)}
		}catch{
			return []
		}
	}
	
	
	
    func generateSAFeed(item: VKFeedElement) -> SAFeedElement {
        let title = item.getText().contains("\n") ? String(item.getText().split(separator: "\n").first ?? "") : ""
        let desc = item.getText().contains("\n") ? String(item.getText().split(separator: "\n").last ?? "") : ""
		let url = "https://vk.com/wall\(item.from_id)_\(item.id)"
		return SAFeedElement(date: item.getDate(), likes: item.getLikes(), comments: item.getComments(), reposts: item.getReposts(), views: item.getViews(), imageURL: item.getPhoto(), title: title, desc: desc, postUrl: url)
    }
    init() {
        self.source = FeedSource(name: "default", id: 0)
    }
    
    init(source : FeedSource){
        self.source = source
    }
}
