//
//  Schedule.User.swift
//  API
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


extension Schedule{
    public struct User :Hashable, Codable{
        public let Name:String
        public let ItemId:Int
    }
}

