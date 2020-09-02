//
//  Feed.swift
//  SUAI_API
//
//  Created by Кирилл on 28.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

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
    public func next() -> [SAFeedElement]{
        var new:[SAFeedElement] = []
        
        guard let data = PocketAPI.shared.syncLoadTask(method: .getFeed, params:[
            "owner_id":self.source.id,
            "count":self.count,
            "offset":self.offset,
        ]) else { return [] }
        do{
            let feed = try JSONDecoder().decode([VKFeedElement].self, from: data)
            for item in feed{
                
                let title = item.getText().contains("\n") ? String(item.getText().split(separator: "\n").first ?? "") : ""
                let desc = item.getText().contains("\n") ? String(item.getText().split(separator: "\n").last ?? "") : ""
                
                new.append(SAFeedElement(date: item.getDate(), likes: item.getLikes(), comments: item.getComments(), reposts: item.getReposts(), views: item.getViews(), imageURL: item.getPhoto(), title: title, desc: desc, postUrl: ""))
                
                self.offset += 1
            }
        }catch{
            print(error)
            return []
        }
        self.feed.append(contentsOf: new)
        return new
    }
    init() {
        self.source = FeedSource(name: "default", id: 0)
    }
    
    init(source : FeedSource){
        self.source = source
    }
}
