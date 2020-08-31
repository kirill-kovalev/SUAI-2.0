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
    
    private var userTimetables : [SAUsers.User:SATimetable] = [:]
    
    public func load(for user: SAUsers.User) -> SATimetable {
        userTimetables[user] = SATimetable(for: user)
        return userTimetables[user]!
    }
    
    public func get(for user: SAUsers.User ) -> SATimetable {
        if userTimetables[user] == nil {
            let _ = self.load(for: user)
        }
        return userTimetables[user] ?? SATimetable()
    }
}



