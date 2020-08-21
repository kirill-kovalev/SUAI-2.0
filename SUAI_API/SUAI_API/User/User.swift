//
//  User.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SAUserSettings: Codable {
    public let group: String = "1611"
    public let idtab: Int = 0
    public let animations: Int = 1
    public let building: Int = 0
    public let banners: Int = 0
    //    public let prologin: String
    //    public let propass: String
    
    public static var shared = fromServer()
    init() {
        
    }
    
    public static func fromServer() -> SAUserSettings?{
        var settings:SAUserSettings?
        PocketAPI.shared.syncLoadTask(method: .getSettings) { (data) in
            do{
                settings = try JSONDecoder().decode(SAUserSettings.self, from: data)
            }catch{
                settings = SAUserSettings()
                
            }
        }
        return settings
    }
    
}
