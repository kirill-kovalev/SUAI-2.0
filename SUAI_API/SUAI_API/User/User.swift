//
//  User.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SAUserSettings: Codable {
    public let group: String
    public let idtab: Int
    public let animations: Int
    public let building: Int
    public let banners: Int
    public let prologin: String
    public let propass: String
    
    public static var shared = fromServer()
    
    public static func fromServer() -> SAUserSettings?{
        var settings:SAUserSettings?
        PocketAPI.shared.syncDataTask(method: .getSettings) { (data) in
            do{
               settings = try JSONDecoder().decode(SAUserSettings.self, from: data)
            }catch{
                print(error)
            }
        }
        return settings
    }
}
