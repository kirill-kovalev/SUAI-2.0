//
//  SADeadline.swift
//  SUAI_API
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

//"""
//
//{
//	"id": 59194,
//	"subject_name": "Информационные системы и технологии",
//	"deadline_name": "Лабораторная работа №1",
//	"closed": 0,
//	"start": "2020-08-29",
//	"end": null,
//	"comment": "",
//	"status_name": "принят",
//	"type_name": "Лабораторная работа",
//	"markpoint": "5",
//	"is_our": 0
//}
//
//"""

public struct SADeadline: Codable {
    public let id: Int
    public var subject_name: String?
    public var deadline_name: String?
    public var closed: Int
    public let start: Date
    public var end: Date?
    public var comment: String
	public var status_name:String?
	public var type_name:String?
	public var markpoint:String?
	internal var is_our:Int
	public var isPro:Bool {is_our == 0}
    
    public var lesson: String {
        return ""
    }
    public init(id: Int = 0,
                subject_name: String? = "",
                deadline_name: String = "",
                closed: Int = 0,
                start: Date = Date(),
                end: Date = Date(),
                comment: String = ""
    ){
        self.id = id
        self.subject_name = subject_name
        self.deadline_name = deadline_name
        self.closed = closed
        self.start = start
        self.end = end
        self.comment = comment
		self.is_our = 1
    }
	public init(proName: String,
				subject_name: String? = "",
				comment: String = ""
	){
		self.init(id: 0, subject_name: subject_name, deadline_name: proName, closed: 1,comment: comment)
		self.is_our = 0
	}
    public var startDate:String{
        return SADeadline.formatter.string(from: self.start)
    }
    public var endDate:String{
        return SADeadline.formatter.string(from: self.end ?? Date())
    }
    public static let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public var type: SADeadlineGroup{
		if self.isPro { return .pro}
		
        if self.closed == 1{
            return .closed
        }else{
            if (self.end ?? Date()) < Date().addingTimeInterval(60*60*24*7){
                return .nearest
            }else{
                return .open
            }
        }
    }
}

