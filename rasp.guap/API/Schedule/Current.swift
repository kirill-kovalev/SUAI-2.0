//
//  Current.swift
//  rasp.guap
//
//  Created by Кирилл on 16.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

class ScheduleCurrent{
    var delegate:scheduleTracker?
    var user:Schedule.User?{
        didSet{
            delegate?.didChange()
        }
    }
    
}
protocol scheduleTracker {
    func didChange()
}
