//
//  PocketAPI.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import SwiftyVK

public class PocketAPI{
    public static var shared = PocketAPI()
    
    public enum LoadMethods:String{
        case getDeadlines = "GetDeadlines"
        case getSettings = "GetSettings"
        case getGroup = "GetGroup"
        case getFeed = "GetFeed"
        case getSuper = "GetSuper"
    }
    public enum SetMethods:String{
        case closeDeadline = "CloseDeadline"
        case openDeadline = "OpenDeadline"
        case deleteDeadline = "DeleteDeadline"
        case editDeadline = "EditDeadline"
        case createDeadline = "SetDeadline"
        
        case setSettings = "SetSettings"
    }
    
    
    let config = URLSessionConfiguration.default
    
    public init(){
        config.httpAdditionalHeaders = ["Token":VK.sessions.default.accessToken?.get()]
    }
    public func setToken(_ token:String){
        config.httpAdditionalHeaders = ["Token":token]
    }
    
    public func syncLoadTask(method: LoadMethods,completion:@escaping (Data)->Void){
        
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
    
    
    public func syncSetTask(method: SetMethods,params:[String:Any],completion:@escaping (Data)->Void){
        let url = URL(string:"https://suaipocket.ru:8000/\(method.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = params.map({ (key,value) in
            let queryKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let queryValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return queryKey+"="+queryValue
        }).joined(separator: "&")
        request.httpBody = body.data(using: .utf8)
        let sem = DispatchSemaphore(value: 0)
        URLSession(configuration: config ).dataTask(with: request){ (data, response, err) in
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
