//
//  ScheduleDaySelectDelegate.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

protocol ScheduleDaySelectDelegate {
    func scheduleDaySelect(didUpdate day:Int,week:Timetable.Week)
    
    func shouldShow(day:Int,week:Timetable.Week)->Bool
}
