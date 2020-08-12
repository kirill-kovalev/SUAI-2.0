//
//  Timetable.swift
//  API
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class Timetable {

    public init(for user: Schedule.User) {
        load(for: user)
    }
    public init() {
        
    }
    
    private var timetable = [Array(repeating: Array<Lesson>(), count: 7),//четная
                     Array(repeating: Array<Lesson>(), count: 7),// нечетная
                     Array(repeating: Array<Lesson>(), count: 7)]//Вне сетки
    
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
        case even = 0
        case odd = 1
        case outOfTable = 2
    }
    
    public func get(week:Week,day:Int) -> [Lesson] {
        return self.timetable[week.rawValue][day].sorted { (l1, l2) -> Bool in
            return l1.lessonNum > l2.lessonNum
        }
    }
    
    
    
    
    
    private func decodeAPIResponse(data:Data?,resp:URLResponse?,err:Error?){
        if err == nil, data != nil {
            if (resp as! HTTPURLResponse).statusCode == 200 {
                do{
                    let decoded = try JSONDecoder().decode([JSONLesson].self, from: data!)
                    
                    decoded.forEach { (lesson) in
                        
                        switch lesson.Week {

                            case 1: // нечетные
                                self.timetable[1][lesson.Day - 1].append(Lesson(from: lesson))
                                break
                            case 2: // четные
                                self.timetable[0][lesson.Day - 1].append(Lesson(from: lesson))
                                break

                            default: // вне сетки
                                self.timetable[2][lesson.Day - 1].append(Lesson(from: lesson))
                                break
                        }
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
                
            } else {print("HTTPURLResponse Code != 200")}
        }else {print("err: \(err?.localizedDescription ?? "")")}
    }
    
    
    
}