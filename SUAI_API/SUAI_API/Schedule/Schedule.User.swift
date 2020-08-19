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
        public var shortName:String {
            let substr = self.Name.split(separator: "—")[0]
            return String(substr)
        }
        public init(Name:String,ItemId:Int){
            self.Name = Name
            self.ItemId  = ItemId
        }
    }
}

