//
//  Schedule.swift
//  API
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class Schedule{
    
    public static let shared = Schedule()
    public let preps = Preps()
    public let groups = Groups()
    public let settings = ScheduleSettings.load()
    public let current = ScheduleCurrent()
    
    private var userTimetables : [User:Timetable] = [:]
    
    public func load(for user: User){
        userTimetables[user] = Timetable(for: user)
    }
    
    public func get(for user: User ) -> Timetable {
        if userTimetables[user] == nil {
            self.load(for: user)
        }
        return userTimetables[user] ?? Timetable()
    }
}



