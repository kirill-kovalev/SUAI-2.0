//
//  Schedule.swift
//  API
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SASchedule{
    
    public static let shared = SASchedule()
    public let preps = Preps()
    public let groups = Groups()
    public let settings = ScheduleSettings.load()
    
    public var userTimetables : [SAUsers.User:SATimetable] = [:]
	
	
	private typealias CachedSchedule = [String:Data]
	
	
	init() {

	}
	public func loadFromCache(){
			if self.groups.count == 0 {self.groups.loadFromCache()}
			if self.preps.count == 0 {self.preps.loadFromCache()}
			let cachedData = UserDefaults.standard.object(forKey: "SAScheduleCache") as? CachedSchedule
			if let cachedData = cachedData{
				self.userTimetables = decodeFromDefaults(cachedData)
			}else{
				print("err \(cachedData)")
			}
	}
	
	private func decodeFromDefaults(_ from: CachedSchedule) -> [SAUsers.User:SATimetable]{
		var data:[SAUsers.User:SATimetable] = [:]
		for (key,val) in from {
			do{
				let user = try JSONDecoder().decode(SAUsers.User.self, from: key.data(using: .utf8) ?? Data() )
//				let newKey = self.preps.get(name: user.Name) ?? self.groups.get(name: user.Name)
				let lessons = try JSONDecoder().decode([SALesson].self, from: val)
//				if let newKey = newKey {
//
//				}
				data[user] = SATimetable(timetable: lessons)
				
			}catch{print(error)}
			
		}
//		print("\n\n\n\n\n\nFrom defaults:")
//		print(data)
//		print(self.get(for: self.groups.get(name: "1040М")!).list())
//		print("______________________________\n\n\n\n\n\n")
		
		return data
	}
	
	private func saveToDefaults(){
		var data:CachedSchedule = [:]
		for (key,val) in self.userTimetables{
			let timetable =  try? JSONEncoder().encode(val.list())
			let user = (try? JSONEncoder().encode(key)) ?? Data()
			let strKey = String(data:user ,encoding: .utf8) ?? ""
			data[strKey] = timetable
			print("set \(strKey) : \(timetable)")
		}
		
		UserDefaults.standard.set(data, forKey: "SAScheduleCache")
	}
    
    public func load(for user: SAUsers.User) -> SATimetable {
		let newTT = SATimetable(for: user)
		if !newTT.isEmpty{
			userTimetables[user] = newTT
			saveToDefaults()
		}
        return userTimetables[user]!
    }
    
    public func get(for user: SAUsers.User ) -> SATimetable {
		let tt = userTimetables[user]
		if tt == nil || (tt?.isEmpty ?? true) {
			print("\nTimetable not found for user \(user). Loading from server\n\n")
            let _ = self.load(for: user)
        }
        return userTimetables[user] ?? SATimetable()
    }
	

}



