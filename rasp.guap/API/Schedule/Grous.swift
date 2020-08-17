//
//  Grous.swift
//  API
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


public class Groups{
    
    public typealias Group = Schedule.User
    
    
    private var groups:[Group] = []
    
    public var count:Int {
        return groups.count
    }
        
    public init() {
        loadFromServer()
    }
    public init(groups:[Group]){
        self.groups = groups
    }
    
    public func loadFromServer(){
        let sem = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: URL(string: "https://api.guap.ru/rasp/custom/get-sem-groups")!) { (data, resp, err) in
            if err == nil, data != nil {
                if (resp as! HTTPURLResponse).statusCode == 200 {
                    do{
                        let decoded = try JSONDecoder().decode([Group].self, from: data!)
                        self.groups = decoded
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            sem.signal()
        }.resume()
        
        let _ = sem.wait(timeout: .distantFuture)
    }
    
    public func get(id:Int) -> Group?{
        return self.groups.filter { (group) -> Bool in
            return group.ItemId == id
        }.first
    }
    public func get(index:Int) -> Group?{
        if index < self.groups.count, index>=0 {
            return self.groups[index]
        }
        return nil
    }
    public func get(name:String) -> Group?{
        return self.groups.filter { (group) -> Bool in
            return group.Name == name
        }.first
    }
    
    public func search(name:String) ->Groups{
        let newGrouplist = self.groups.filter { (user) -> Bool in
            return name.lowercased().contains(user.Name.lowercased())
        }
        return Groups(groups: newGrouplist)
    }
    
    public func sorted(sort: (Schedule.User,Schedule.User)->Bool   ) -> Groups{
        return Groups(groups: self.groups.sorted(by: sort))
    }
    
    
}
