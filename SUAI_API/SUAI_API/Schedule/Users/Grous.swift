//
//  Grous.swift
//  API
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


public class Groups :SAUsers{
    
    
    
        
    public override init() {
        super.init()
        loadFromServer()
    }
    
    required init(users: [User]) {
        super.init(users: users)
    }
    
    public func loadFromServer(){
        let sem = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: URL(string: "https://api.guap.ru/rasp/custom/get-sem-groups")!) { (data, resp, err) in
            if err == nil, data != nil {
                if (resp as! HTTPURLResponse).statusCode == 200 {
                    do{
                        let decoded = try JSONDecoder().decode([User].self, from: data!)
                        self.users = decoded
                    }catch{
                        print("Groups: \(error)")
                    }
                }
            }
            sem.signal()
        }.resume()
        let _ = sem.wait(timeout: .distantFuture)
    }
    
    
    
    
    
    
}
