//
//  Timetable.swift
//  API
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class Timetable {
    public static let lessonHours:[[DateComponents]] = [
        [.init(hour: 09, minute: 00),.init(hour: 10, minute: 30)],//1
        [.init(hour: 10, minute: 40),.init(hour: 12, minute: 10)],//2
        [.init(hour: 12, minute: 20),.init(hour: 13, minute: 50)],//3
        [.init(hour: 14, minute: 10),.init(hour: 15, minute: 40)],//4
        [.init(hour: 15, minute: 50),.init(hour: 17, minute: 20)],//5
        [.init(hour: 17, minute: 30),.init(hour: 19, minute: 00)]//6
        
    ]

    public init(for user: Schedule.User) {
        load(for: user)
    }
    public init() {
        
    }
    
    private var timetable = [Lesson]()//Вне сетки
    
    public func load(for user: Schedule.User){
        
        let type = user.Name.contains(" — ") ? "prep" : "group"
        
        let url = URL(string: "https://api.guap.ru/rasp/custom/get-sem-rasp/\(type)\(user.ItemId)")!
        let sem = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            self.decodeAPIResponse(data: data, resp: resp, err: err)
            sem.signal()
        }.resume()
        let _ = sem.wait(timeout: .distantFuture)
    }
    
    public enum Week:Int {
        case outOfTable = 0
        case odd = 1
        case even = 2
    }
    
    public func get(week:Week,day:Int) -> [Lesson] {
        return self.timetable.filter({ lesson in
            return lesson.week == week && lesson.day == day
        }).sorted { (l1, l2) -> Bool in
            return l1.lessonNum < l2.lessonNum
        }
    }
    
    public var isEmpty:Bool{
        return  self.timetable.isEmpty
    }
    
    
    
    
    private func decodeAPIResponse(data:Data?,resp:URLResponse?,err:Error?){
        if err == nil, data != nil {
            if (resp as! HTTPURLResponse).statusCode == 200 {
                do{
                    let decoded = try JSONDecoder().decode([Lesson.JSONLesson].self, from: data!)
                    
                    decoded.forEach { (lesson) in
                        self.timetable.append(Lesson(from: lesson))
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
                
            } else {print("HTTPURLResponse Code != 200")}
        }else {print("err: \(err?.localizedDescription ?? "")")}
    }
    
    
    
}
