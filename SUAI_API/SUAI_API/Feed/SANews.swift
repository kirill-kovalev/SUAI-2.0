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
    public static let shared = SANews()
    public var streams:[SAFeedStream] = []
    
    public func loadSourceList(){
        guard let data = PocketAPI.shared.syncLoadTask(method: .getFeedOrder) else {return}
        do{
            let a = try JSONDecoder().decode([FeedSource].self, from: data)
            self.streams = []
            for (source) in a{
                //let source = FeedSource(name: key, owner_id: value)
                self.streams.append(SAFeedStream(source: source))
            }
        }catch{
            print(error)
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
}
