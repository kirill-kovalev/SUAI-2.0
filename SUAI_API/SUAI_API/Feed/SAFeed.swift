//
//  SAFeed.swift
//  SUAI_API
//
//  Created by Кирилл on 28.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public struct FeedSource{
    public let name:String
    public let owner_id:Int
}

public class SAFeed{
    public var sourcelist:[FeedSource] = []
    
    public func loadSourceList(){
        self.sourcelist = []
        
        let _ = PocketAPI.shared.syncLoadTask(method: .getFeedOrder) { (data) in
            do{
                let a = try JSONDecoder().decode([String:Int].self, from: data)
                for (key,value) in a{
                    self.sourcelist.append(FeedSource(name: key, owner_id: value))
                }
            }catch{
                print(error)
            }
        }
        
    }
}
