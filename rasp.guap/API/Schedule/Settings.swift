//
//  Settings.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

struct ScheduleSettings:Codable {
    let Years: String
    let IsAutumn: Bool
    let Update: String
    let CurrentWeek: Int
    let IsWeekOdd: Bool
    let IsWeekUp: Bool
    let IsWeekRed: Bool
    
    var week:Timetable.Week{
        return IsWeekOdd ? .odd : .even
    }
    
    
    
    static func load() -> ScheduleSettings?{
        let sem = DispatchSemaphore(value: 0)
        var loaded:ScheduleSettings?
        URLSession(configuration: .default).dataTask(with: URL(string:"https://api.guap.ru/rasp/custom/get-sem-info")!) { (data, resp, err) in
                        if err == nil, data != nil {
                if (resp as! HTTPURLResponse).statusCode == 200 {
                    do{
                        loaded = try JSONDecoder().decode(ScheduleSettings.self, from: data!)
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                } else {print("HTTPURLResponse Code != 200")}
            }else {print("err: \(err?.localizedDescription ?? "")")}
            
            sem.signal()
        }.resume()
        sem.wait()
        return loaded
    }
}

