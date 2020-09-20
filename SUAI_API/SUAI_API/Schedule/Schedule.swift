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
    public var settings = ScheduleSettings.load()
    
    public var userTimetables : [SAUsers.User:SATimetable] = [:]
	
	
	private typealias CachedSchedule = [String:Data]
	
	
	init() {

	}
	public func loadFromCache(){
			if self.groups.count == 0 {self.groups.loadFromCache()}
			if self.preps.count == 0 {self.preps.loadFromCache()}
			//timetables
			let cachedData = UserDefaults.standard.object(forKey: "SAScheduleCache") as? CachedSchedule
			if let cachedData = cachedData{
				self.userTimetables = decodeFromDefaults(cachedData)
			}else{
				print("err cachedData = nil")
			}
		//settings
		if let cachedSettings = UserDefaults.standard.object(forKey: "SAScheduleSettingsCache") as? Data,
			let decoded = try? JSONDecoder().decode(ScheduleSettings.self, from: cachedSettings) {
			self.settings = decoded
		}
	}
	
	private func decodeFromDefaults(_ from: CachedSchedule) -> [SAUsers.User:SATimetable]{
		var data:[SAUsers.User:SATimetable] = [:]
		for (key,val) in from {
			do{
				let user = try JSONDecoder().decode(SAUsers.User.self, from: key.data(using: .utf8) ?? Data() )
				let lessons = try JSONDecoder().decode([SALesson].self, from: val)
				data[user] = SATimetable(timetable: lessons)
			}catch{print(error)}
		}
		return data
	}
	
	private func saveToDefaults(){
		//timetables
		var data:CachedSchedule = [:]
		for (key,val) in self.userTimetables{
			let timetable =  try? JSONEncoder().encode(val.list())
			let user = (try? JSONEncoder().encode(key)) ?? Data()
			let strKey = String(data:user ,encoding: .utf8) ?? ""
			data[strKey] = timetable

		}
		UserDefaults.standard.set(data, forKey: "SAScheduleCache")
		
		//settings
		if let encoded = try? JSONEncoder().encode(self.settings){
			UserDefaults.standard.set(encoded, forKey: "SAScheduleSettingsCache")
		}
	}
    
    public func load(for user: SAUsers.User) -> SATimetable {
		let newTT = SATimetable(for: user)
		if !newTT.isEmpty{
			userTimetables[user] = newTT
			saveToDefaults()
		}
        return newTT
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



