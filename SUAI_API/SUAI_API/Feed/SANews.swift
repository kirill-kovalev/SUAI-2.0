//
//  SAFeed.swift
//  SUAI_API
//
//  Created by Кирилл on 28.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public struct FeedSource:Codable{
    public let name:String
    public let id:Int
}

public class SANews{
	private var userDefaultsKey:String {"\(Self.self)Cache"}
    
    public static let shared = SANews()
    public var streams:[SAFeedStream] = []
    
    public func loadSourceList(){
		if let data = PocketAPI.shared.syncLoadTask(method: .getFeedOrder) ?? UserDefaults.standard.data(forKey: self.userDefaultsKey){
			do{
				let decodedData  = try JSONDecoder().decode([FeedSource].self, from: data)
				self.streams = []
				for (source) in decodedData {
					self.streams.append(SAFeedStream(source: source))
				}
				UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
			}catch{
				print("SANews source list: \(error)")
			}
		}
        
    }
    
    public func get(name:String)->SAFeedStream?{
        return self.streams.filter { (stream) in
            return stream.source.name.contains(name)
        }.first
    }
    public func get(index:Int)->SAFeedStream?{
        if index < self.streams.count && index >= 0 && !self.streams.isEmpty{
            return self.streams[index]
        }
        return nil
    }
    public var sources:[FeedSource]{
        self.streams.map{$0.source}
    }
    
    public init(){
        
    }
}
