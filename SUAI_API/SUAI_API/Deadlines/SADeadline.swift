//
//  SADeadline.swift
//  SUAI_API
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public struct SADeadline: Codable {
    public let id: Int
    public var subject_name: String?
    public var deadline_name: String?
    public var closed: Int
    public let start: Date
    public var end: Date
    public var comment: String
    
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
    }
    public var startDate:String{
        return SADeadline.formatter.string(from: self.start)
    }
    public var endDate:String{
        return SADeadline.formatter.string(from: self.end)
    }
    public static let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public var type: SADeadlineGroup{
        if self.closed == 1{
            return .closed
        }else{
            if self.end < Date().addingTimeInterval(60*60*24*7){
                return .nearest
            }else{
                return .open
            }
        }
    }
}
