//
//  Schedule.Timetable.swift
//  API
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public struct SALesson{
    public enum LessonType :String {
        case lab = "ЛР"
        case lecture = "Л"
        case courseProject = "КП"
        case practice = "ПР"
    }
    
    public let name:String
    public let lessonNum:Int
    public let type:LessonType
    public var groups:[SAUsers.User] = []
    public var prepods:[SAUsers.User] = []
    public var tags:[String] = []
    var week:SATimetable.Week
    var day:Int
    var itemID: Int
    
    
    public var startTime:DateComponents {
        if lessonNum == 0 {
            return DateComponents(hour: 00, minute: 00)
        }
        return SATimetable.lessonHours[self.lessonNum - 1][0]
    }
    public var endTime:DateComponents {
        if lessonNum == 0 {
            return DateComponents(hour: 00, minute: 00)
        }
        return SATimetable.lessonHours[self.lessonNum - 1][1]
    }
    
    public init(name:String = "",
                lessonNum:Int = 1,
                type:LessonType = .lab,
                prepod:SAUsers.User?=nil,
                group:SAUsers.User?=nil,
                tags:[String]=[],
                week:SATimetable.Week = .even,
                day:Int = 0
    ){
        self.name = name
        self.lessonNum = lessonNum
        self.type = type
        self.groups = group != nil ? [group!] : []
        self.prepods = prepod != nil ? [prepod!] : []
        self.tags = tags
        self.week = week
        self.day = day
        self.itemID = -1
    }
    
    init(from:JSONLesson) {
        
        if from.Preps != nil{
            for seq in  from.Preps!.split(separator: ":"){
                let id = Int(String(seq))
                if id != nil  {
                    let prepod = SASchedule.shared.preps.get(id: id!)
                    if prepod != nil {
                        self.prepods.append(prepod!)
                    }
                }
            }
        }
        
        for seq in  from.Groups.split(separator: ":"){
            let id = Int(String(seq))
            if id != nil  {
                let group = SASchedule.shared.groups.get(id: id!)
                if group != nil {
                    self.groups.append(group!)
                }
            }
        }
        
        self.name = from.Disc
        self.type =  LessonType(rawValue: from.Type) ?? .lab
        self.lessonNum = from.Less
        self.week = SATimetable.Week(rawValue: from.Week) ?? .odd
        self.day = from.Day - 1
        self.itemID = from.ItemId
        if from.Build != nil ,from.Rooms != nil {
            self.tags.append("\(from.Build!) \(from.Rooms!)" )
        }
        
        
    }
}

