//
//  SATimetable.swift
//  API
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SATimetable {
    public static let lessonHours:[[DateComponents]] = [
        [.init(hour: 09, minute: 30),.init(hour: 11, minute: 00)],//1
        [.init(hour: 11, minute: 10),.init(hour: 12, minute: 40)],//2
        [.init(hour: 13, minute: 00),.init(hour: 14, minute: 30)],//3
        [.init(hour: 15, minute: 00),.init(hour: 16, minute: 30)],//4
        [.init(hour: 16, minute: 40),.init(hour: 18, minute: 10)],//5
        [.init(hour: 18, minute: 30),.init(hour: 20, minute: 00)],//6
		[.init(hour: 20, minute: 10),.init(hour: 21, minute: 40)],//7
		[.init(hour: 21, minute: 50),.init(hour: 23, minute: 20)]//8
        
    ]
	//['09:30-11:30', '11:10-12:40', '13:00-14:30', '15:00-16:30', '16:40-18:10', '18:30-20:00', '20:10-21:40']
    public init(for user: SAUsers.User) {
        let _ = load(for: user)
    }
    public init() {
        
    }
	init(timetable:[SALesson]){
		self.timetable = timetable
	}
    private var timetable = [SALesson]()//список пар
    
    public func load(for user: SAUsers.User) -> Self{
        
        let type = user.Name.contains(" — ") ? "prep" : "group"
        
        let url = URL(string: "https://api.guap.ru/rasp/custom/get-sem-rasp/\(type)\(user.ItemId)")!
        let sem = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            self.decodeAPIResponse(data: data, resp: resp, err: err)
            sem.signal()
        }.resume()
        let _ = sem.wait(timeout: .distantFuture)
        return self
    }

    
	public enum Week:Int{
        case outOfTable = 0
        case odd = 1
        case even = 2
    }
    
    public func get(week:Week,day:Int) -> [SALesson] {
        return self.timetable.filter({ lesson in
            return lesson.week == week && lesson.day == day
        }).sorted { (l1, l2) -> Bool in
            return l1.lessonNum < l2.lessonNum
        }
    }
    public func get(itemID:Int) -> [SALesson]{
        return self.timetable.filter({ lesson in
            return lesson.itemID == itemID
        }).sorted { (l1, l2) -> Bool in
            return l1.lessonNum < l2.lessonNum
        }
    }
    public func get(name:String) -> [SALesson]{
        return self.timetable.filter({ lesson in
            return lesson.name.contains(name)
        }).sorted { (l1, l2) -> Bool in
            return l1.lessonNum < l2.lessonNum
        }
    }
    public func list() -> [SALesson]{
		
		let lessonNames = Array(Set(self.timetable.map{ $0.name}))
		return lessonNames.compactMap { (name) in
			self.timetable.filter {$0.name == name}.first
		}
    }
    
    public var isEmpty:Bool{
        return  self.timetable.isEmpty
    }
    
    
    
    
    private func decodeAPIResponse(data:Data?,resp:URLResponse?,err:Error?){
        if err == nil, data != nil {
            if (resp as! HTTPURLResponse).statusCode == 200 {
                do{
                    let decoded = try JSONDecoder().decode([SALesson.JSONLesson].self, from: data!)
                    
                    decoded.forEach { (lesson) in
                        self.timetable.append(SALesson(from: lesson))
                    }
                    
                }catch{
                    print("SATimetable: \(error)")
                }
                
            } else {print("HTTPURLResponse Code != 200")}
        }else {print("SATimetable: \(err?.localizedDescription ?? "")")}
    }
    
    
    
}
