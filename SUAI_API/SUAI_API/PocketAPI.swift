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
        case getFeedOrder = "GetFeedOrder"
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
        if !VK.needToSetUp && VK.sessions.default.state == .authorized {
            config.httpAdditionalHeaders = ["Token":VK.sessions.default.accessToken?.get() ?? ""]
        }
    }
    public func setToken(_ token:String){
        config.httpAdditionalHeaders = ["Token":token]
    }
    
    public func syncLoadTask(method: LoadMethods,params: [String:Any] = [:],completion:((Data)->Void)? = nil ) -> Data?{
        
        let sem = DispatchSemaphore(value: 0)

        let urlParams = params.isEmpty ? "" : "?"+params.map{"\($0)=\($1)"}.joined(separator: "&")
        let url = URL(string:"https://suaipocket.ru:8000/\(method.rawValue)"+urlParams)!
        
        var returnData:Data? = nil
        URLSession(configuration: config ).dataTask(with: url ) { (data, response, err) in
            if err == nil {
                if data != nil {
                    returnData = data
                    completion?(data!)
                }
            }
            sem.signal()
        }.resume()
        sem.wait()
        return returnData
    }
    
    
    public func syncSetTask(method: SetMethods,params:[String:Any] = [: ],completion: ((Data)->Void)? ) -> Data?{
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
        
        var returnData:Data? = nil
        URLSession(configuration: config ).dataTask(with: request){ (data, response, err) in
            if err == nil {
                if data != nil {
                    returnData = data
                    completion?(data!)
                }
            }
            sem.signal()
        }.resume()
        sem.wait()
        
        return returnData
    }
}
