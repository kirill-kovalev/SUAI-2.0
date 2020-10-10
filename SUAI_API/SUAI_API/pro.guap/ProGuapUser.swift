//
//  ProGuapUser.swift
//  SUAI_API
//
//  Created by Кирилл on 10.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


public struct GuapUser :Codable{
	public let id: String?
	public let user_id: String?
	public let lastname: String?
	public let firstname: String?
	public let middlename: String?
	public let email: String?
	public let phone: String?
	public let auditorium: String?
	public let image: String?
	public let academic_title: String
	public let degree: String?
	public let STID: String?
	public let eid: String?
	public let eduIDEP: String?
	public let GraduateDate: String?
	public let status: String?
	public let grIDEP: String?
	public let grid: String?
	public let currentSemester: String?
	
	static func parse(_ text:String) -> GuapUser? {
		if let regexp = try? NSRegularExpression(pattern: "\\{\"user\":\\[(.+)\\]", options: []){
		 let range = NSRange(location: 0,length: text.count)
		 for match in regexp.matches(in: text, options: [], range: range){
			 
			 let strRang = Range(match.range,in:text)!
			 let foundStr = String(text[strRang])
			 let data = regexp.stringByReplacingMatches(in: foundStr, options: [], range: NSRange(location: 0,length: foundStr.count), withTemplate: "$1").data(using: .utf8) ?? Data()
			 return try? JSONDecoder().decode(GuapUser.self, from: data)
		 }
	 }
	 return nil
 }
}
