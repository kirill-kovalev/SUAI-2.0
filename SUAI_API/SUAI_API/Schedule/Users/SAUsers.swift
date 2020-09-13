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
	var source:String {""}
    
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
	
	private lazy var userDefaultsKey:String = {"\(Self.self)Cache"}()
	public func loadFromServer(){
        let sem = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: URL(string: source)!) { (data, resp, err) in
            if err == nil, data != nil {
                if (resp as! HTTPURLResponse).statusCode == 200 {
                    do{
                        let decoded = try JSONDecoder().decode([User].self, from: data!)
                        self.users = decoded
						UserDefaults.standard.set(data!, forKey: self.userDefaultsKey)
                    }catch{
						print("\(Self.self) \(#function): \(error)")
                    }
                }
            }
            sem.signal()
        }.resume()
        
        let _ = sem.wait(timeout: .distantFuture)
    }
	
	public func loadFromCache(){
		guard let data = UserDefaults.standard.data(forKey: self.userDefaultsKey) else {return}
		do{
			let decoded = try JSONDecoder().decode([User].self, from: data)
			self.users = decoded
		}catch{
			print("\(Self.self) \(#function): \(error)")
		}
	}
}

