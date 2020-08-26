//
//  User.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SAUserSettings: Codable {
    public var group: String?
    public var idtab: Int
    public var animations: Int
    public var building: Int
    public var banners: Int
    //    public let prologin: String
    //    public let propass: String
    
    public static var shared = fromServer()
    
    
    public static func fromServer() -> SAUserSettings?{
        var settings:SAUserSettings?
        PocketAPI.shared.syncLoadTask(method: .getSettings) { (data) in
            do{
                settings = try JSONDecoder().decode(SAUserSettings.self, from: data)
               
            }catch{
                settings = nil
                print(error)
                print(String(data: data, encoding: .utf8)!)
            }
        }
        return settings
    }
    public func reload(){
        guard let settings = SAUserSettings.fromServer() else{
            return
        }
        self.group = settings.group
        self.idtab = settings.idtab
        self.animations = settings.animations
        self.building = settings.building
        self.banners = settings.banners
        
    }
    public func update() -> Bool{
        var success = false
        PocketAPI.shared.syncSetTask(method: .setSettings , params: [
            "group":self.group!,
            "idtab":self.idtab,
            "animations":self.animations,
            "building":self.building,
            "banners":self.banners
        ]) { (data) in
            success = String(data: data, encoding: .utf8)?.contains("success") ?? false
        }
        return success
    }
    
}
