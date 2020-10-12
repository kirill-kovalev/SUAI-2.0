//
//  ProGuapTask.swift
//  SUAI_API
//
//  Created by Кирилл on 10.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


public struct ProTask:Codable{
	public let id: String
	public let user_id: String
	public let datecreate: Date
	public let dateupdate: Date
	public let name: String
	public let description: String
	public let `public`: String
	public let semester: String
	public let markpoint: String
	public let reportRequired: String
	public let url: String?
	public let ordernum: String?
	public let expulsionLine: String
	public let plenty: String
	public let harddeadline: String?
	public var subject_name: String
	public let hash: String?
	public let filename: String?
	public let type_name: String
	public let curPoints: String?
	public let status_name: String?
	
	// MARK: - Task
	public struct Detailed:Codable{
		public let id: String
		public let user_id: String
		let filelink: String
		public var link:URL? {
			guard filename != nil  else{return nil}
			return URL(string: "https://pro.guap.ru/\(filelink)")
		}
		public let filename: String?
		public let groups: [String]
		public let fio: String
	}
	
	private var detailed:Detailed? = nil
	mutating func getDetailed() -> Detailed? {
		guard let id = Int(self.id) else {return nil}
		self.detailed = self.detailed ?? ProGuap.shared.getDetailedTask(id: id)
		return self.detailed
	}
}
