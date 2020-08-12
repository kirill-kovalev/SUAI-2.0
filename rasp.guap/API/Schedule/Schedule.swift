//
//  Schedule.swift
//  API
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class Schedule{
    
    static let shared = Schedule()
    let preps = Preps()
    let groups = Groups()
    
    private var userTimetables : [User:Timetable] = [:]
    
    func load(for user: User){
        userTimetables[user] = Timetable(for: user)
    }
    
    public func get(for user: User ) -> Timetable {
        return userTimetables[user] ?? Timetable()
    }
}


