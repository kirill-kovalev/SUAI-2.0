//
//  Current.swift
//  rasp.guap
//
//  Created by Кирилл on 16.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class ScheduleCurrent{
    public var delegate:ScheduleTrackerProtocol?
    public var user:SAUsers.User?{
        didSet{
            delegate?.didChange()
        }
    }
    
}
public protocol ScheduleTrackerProtocol {
    func didChange()
}
