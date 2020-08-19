//
//  PocketAPI.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

class PocketAPI{
    public static var shared = PocketAPI()
    
    public enum Methods:String{
        case getDeadlines = "GetDeadlines"
        case getSettings = "GetSettings"
        case getGroup = "GetGroup"
        case getFeed = "GetFeed"
        case getSuper = "GetSuper"
    }
    public func syncDataTask(method: Methods,completion:@escaping (Data)->Void){
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Referer":"https://dev.suaipocket.ru/?vk_access_token_settings=notify&vk_app_id=6895280&vk_are_notifications_enabled=0&vk_is_app_user=1&vk_is_favorite=0&vk_language=ru&vk_platform=desktop_web&vk_ref=other&vk_user_id=87478742&sign=XqVYJv8y4r6nn1bCSJHKLips3x8PDujYjD7OmNKJ15M"]

        
        let sem = DispatchSemaphore(value: 0)
        let url = URL(string:"https://suaipocket.ru:8000/\(method.rawValue)")!
        URLSession(configuration: config ).dataTask(with: url ) { (data, response, err) in
            if err == nil {
                if data != nil {
                    completion(data!)
                }
            }
            sem.signal()
        }.resume()
        sem.wait()
    }
}
