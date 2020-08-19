//
//  Preps.swift
//  API
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


public class Preps{
    
    public typealias Prepod = Schedule.User
    
    
    
    private var users:[Prepod] = []
    
    public var count:Int {
        return users.count
    }
        
    public init() {
        loadFromServer()
    }
    
    public func loadFromServer(){
        let sem = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: URL(string: "https://api.guap.ru/rasp/custom/get-sem-preps")!) { (data, resp, err) in
            if err == nil, data != nil {
                if (resp as! HTTPURLResponse).statusCode == 200 {
                    do{
                        let decoded = try JSONDecoder().decode([Prepod].self, from: data!)
                        self.users = decoded
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
            sem.signal()
        }.resume()
        
        let _ = sem.wait(timeout: .distantFuture)
    }
    
    public func get(id:Int) -> Prepod?{
        return self.users.filter { (prep) -> Bool in
            return prep.ItemId == id
        }.first
    }
    public func get(index:Int) -> Prepod?{
        if index < self.users.count, index>=0 {
            return self.users[index]
        }
        return nil
    }
    public func get(name:String) -> Prepod?{
        return self.users.filter { (prep) -> Bool in
            return prep.Name == name
        }.first
    }
    
}
