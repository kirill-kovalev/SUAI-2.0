//
//  FeedElement.swift
//  SUAI_API
//
//  Created by Кирилл on 28.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import SwiftyVK

public struct SAFeedElement:Codable{
	public var source:FeedSource
    public var date:Date
    
    public var likes:Int
    public var comments:Int
    public var reposts:Int
    public var views:Int
    
    public var imageURL:String?
    
	public var text:String
	public var title:String {text.contains("\n") ? String(text.split(separator: "\n").first ?? "") : self.text}
    public var desc:String {text.contains("\n") ? String(text.split(separator: "\n").first ?? "") : ""}
    
    public var postUrl:String
	
	static func fromVK(_ item:VKFeedElement)->SAFeedElement{
		let sources:[FeedSource] = SANews.shared.sources.isEmpty ? [
			FeedSource(name: "ГУАП" , id: -122496494),
			FeedSource(name: "Профком" , id: -232453),
			FeedSource(name: "Медиа" , id: -5515524),
			FeedSource(name: "Спорт" , id: -138336798),
			FeedSource(name: "Музгуап" , id: -66449391),
			FeedSource(name: "Гараж" , id: -149885408),
			FeedSource(name: "КВН" , id: -9187),
			FeedSource(name: "Афиша", id: -199089522)
		] : SANews.shared.sources
		
		
		
		let url = "vk.com/wall\(item.from_id)_\(item.id)"
		
		
		
		var element = SAFeedElement(source: FeedSource(name: "", id: item.owner_id ?? 0) , date: item.getDate(), likes: item.getLikes(), comments: item.getComments(), reposts: item.getReposts(), views: item.getViews(), imageURL: item.getPhoto(), text: item.getText(), postUrl: url)
		
		if let source = sources.filter({ abs($0.id) == abs(item.owner_id ?? 0 )}).first {
			element.source = source
			return element
		}
		do{
			guard !VK.needToSetUp else { throw VKError.authorizationDenied }
			struct VKGetNameResponse:Codable{var name:String}
			let resp = try VK.API.Groups.getById([.groupIds:"\(abs(item.owner_id ?? 0 ))"]).synchronously().send() ?? Data()
			let decoded = try JSONDecoder().decode([VKGetNameResponse].self, from: resp).first
			
			element.source = FeedSource(name: decoded?.name ?? "", id: item.owner_id ?? 0)
		}catch{
			print(error)
		}
		return element
		
	}
	static private func parseLinks(){
		let pattern = "[]"
		if let regexp = try? NSRegularExpression(pattern: pattern, options: .allowCommentsAndWhitespace){
			
		}
		
	}
}
