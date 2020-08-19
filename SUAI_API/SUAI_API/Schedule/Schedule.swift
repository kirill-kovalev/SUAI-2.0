//
//  Schedule.swift
//  API
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SASchedule{
    
    public static let shared = SASchedule()
    public let preps = Preps()
    public let groups = Groups()
    public let settings = ScheduleSettings.load()
    public let current = ScheduleCurrent()
    
    private var userTimetables : [SAUsers.User:SATimetable] = [:]
    
    public func load(for user: SAUsers.User){
        userTimetables[user] = SATimetable(for: user)
    }
    
    public func get(for user: SAUsers.User ) -> SATimetable {
        if userTimetables[user] == nil {
            self.load(for: user)
        }
        return userTimetables[user] ?? SATimetable()
    }
}



