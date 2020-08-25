//
//  Schedule.User.swift
//  API
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


public class SAUsers{
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
    
    
    var users:[User] = []
    
    required init(users:[User]) {
        self.users = users
    }
    init() {
        
    }
    
    public var count:Int {
        return users.count
    }
    
    public func get(id:Int) -> User?{
        return self.users.filter { (prep) -> Bool in
            return prep.ItemId == id
        }.first
    }
    public func get(index:Int) -> User?{
        if index < self.users.count, index>=0 {
            return self.users[index]
        }
        return nil
    }
    public func get(name:String) -> User?{
        return self.users.filter { (prep) -> Bool in
            return prep.Name == name
        }.first
    }
    public func search(name:String) -> Self{
        let newUserlist = self.users.filter { (user) -> Bool in
            return user.Name.lowercased().contains(name.lowercased())
        }
        
        return Self(users: newUserlist)
    }
    
    public func sorted(sort: (SAUsers.User,SAUsers.User)->Bool   ) -> Self{
        return Self(users: self.users.sorted(by: sort))
    }
}

