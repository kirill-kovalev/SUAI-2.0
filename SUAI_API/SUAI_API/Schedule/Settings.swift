//
//  Settings.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public struct ScheduleSettings:Codable {
    let Years: String
    let IsAutumn: Bool
    let Update: String
    var CurrentWeek: Int
    var IsWeekOdd: Bool
    
    public var week:SATimetable.Week{
        return IsWeekOdd ? .odd : .even
    }
	public var weekNum:Int { self.CurrentWeek }
    
	public mutating func calculateWeek(){
		let curWeek = Calendar.current.component(.weekOfYear, from: Date())
		
		let year = Calendar.current.component(.year, from: Date())
		let firstOfSeptember = Calendar.current.date(from: DateComponents(year: year, month: 09, day: 1)) ?? Date()
		let firstOfSeptemberWeek = Calendar.current.component(.weekOfYear, from: firstOfSeptember)
		let week = abs(curWeek - firstOfSeptemberWeek) + 1
		
		self.CurrentWeek = week
		self.IsWeekOdd = week % 2 != 0
	}
    
    
    public static func load() -> ScheduleSettings?{
        let sem = DispatchSemaphore(value: 0)
        var loaded:ScheduleSettings?
        URLSession(configuration: .default).dataTask(with: URL(string:"https://api.guap.ru/rasp/custom/get-sem-info")!) { (data, resp, err) in
			if err == nil, data != nil {
                if (resp as! HTTPURLResponse).statusCode == 200 {
                    do{
                        loaded = try JSONDecoder().decode(ScheduleSettings.self, from: data!)
                        
                    }catch{
                        print("chedule settings: \(error)")
                    }
                } else {print("HTTPURLResponse Code != 200")}
            }else {print("err: \(err?.localizedDescription ?? "")")}
            
            sem.signal()
        }.resume()
        sem.wait()
        return loaded
    }
}

