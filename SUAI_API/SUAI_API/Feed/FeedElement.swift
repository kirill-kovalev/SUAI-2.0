//
//  FeedElement.swift
//  SUAI_API
//
//  Created by Кирилл on 28.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public struct SAFeedElement{
	public var source:FeedSource
    public var date:Date
    
    public var likes:Int
    public var comments:Int
    public var reposts:Int
    public var views:Int
    
    public var imageURL:String?
    
    public var title:String
    public var desc:String
    
    public var postUrl:String
}
