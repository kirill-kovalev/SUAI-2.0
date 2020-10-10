//
//  ProGuapUser.swift
//  SUAI_API
//
//  Created by Кирилл on 10.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


struct GuapUser :Codable{
	let id: String?
	let user_id: String?
	let lastname: String?
	let firstname: String?
	let middlename: String?
	let email: String?
	let phone: String?
	let auditorium: String?
	let image: String?
	let academic_title: String
	let degree: String?
	let STID: String?
	let eid: String?
	let eduIDEP: String?
	let GraduateDate: String?
	let status: String?
	let grIDEP: String?
	let grid: String?
	let currentSemester: String?
	
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
