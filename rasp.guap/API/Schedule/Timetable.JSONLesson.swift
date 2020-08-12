//
//  Timetable.JSONLesson.swift
//  API
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

extension Timetable{
    struct JSONLesson : Codable{
        var ItemId: Int
        var Week: Int
        var Day: Int
        var Less: Int
        var Build: String?
        var Rooms: String?
        var Disc: String
        var `Type`:String
        var Groups:String
        var Preps: String?
    }
}
