//
//  ProGuapTask.swift
//  SUAI_API
//
//  Created by Кирилл on 10.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


public struct ProTask:Codable{
	let id: String
	let user_id: String
	let datecreate: Date
	let dateupdate: Date
	let name: String
	let description: String
	let type: String
	let ttName: String
	let `public`: String
	let semester: String
	let markpoint: String
	let reportRequired: String
	let url: String?
	let ordernum: String
	let expulsionLine: String
	let plenty: String
	let harddeadline: String?
	let grid: String
	var subject: String
	var subjectName: String
	let hash: String
	let filename: String
	let semesterName: String
	let typeName: String
	let status: String?
	let curPoints: String?
	let statusName: String?
	
}
