//
//  Feed.swift
//  SUAI_API
//
//  Created by Кирилл on 28.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SAFeedStream{
    public let source:FeedSource
    public var feed:[SAFeedElement] = []
    public var offset:Int = 0
    
    private let count = 20
    
    public func reload(){
        self.offset = 0
        self.feed = []
        let _ = next()
    }
    public func next() -> [SAFeedElement]{
        var new:[SAFeedElement] = []
        
        let _ = PocketAPI.shared.syncLoadTask(method: .getFeed, params:[
            "owner_id":self.source.owner_id,
            "count":self.count,
            "offset":self.offset,
        ]) { (data) in
            do{
                let feed = try JSONDecoder().decode([VKFeedElement].self, from: data)
                for item in feed{
                    let title = String(item.getText().split(separator: "\n").first ?? "")
                    let desc = String(item.getText().split(separator: "\n").last ?? "")
                    
                    new.append(SAFeedElement(date: item.getDate(), likes: item.getLikes(), comments: item.getComments(), reposts: item.getReposts(), imageURL: item.getPhoto(), title: title, desc: desc, postUrl: ""))
                    
                    self.offset += 1
                }
            }catch{
                print(error)
            }
        }
        self.feed.append(contentsOf: new)
        return new
    }
    
    init(source : FeedSource){
        self.source = source
        reload()
    }
}
