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
    public var prologin: String?
    public var propass: String?
	public var procookie:String?
	
	public var proSupport:Bool{return !(prologin?.isEmpty ?? true || propass?.isEmpty ?? true || procookie?.isEmpty ?? true)}
    
    public static var shared = fromServer() ?? fromCache()
    
    
    public static func fromServer() -> SAUserSettings?{
        var settings:SAUserSettings?
        let _ = PocketAPI.shared.syncLoadTask(method: .getSettings) { (data) in
            do{
                settings = try JSONDecoder().decode(SAUserSettings.self, from: data)
                UserDefaults.standard.set(data, forKey: "\(Self.self)" )
            }catch{
                settings = nil
                print("Settings Server: \(error)")
            }
        }
        return settings
    }
    public static func fromCache() -> SAUserSettings?{
        var settings:SAUserSettings?
        guard let data = UserDefaults.standard.data(forKey: "\(Self.self)" ) else {return nil }
        do{
            settings = try JSONDecoder().decode(SAUserSettings.self, from: data)
           
        }catch{
            settings = nil
            print("Settings Cache: \(error)")
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
		self.prologin = settings .prologin
		self.propass = settings.propass
    }
    public func update() -> Bool{
        var success = false
		var params:[String : Any] = [
            "group":self.group!,
            "idtab":self.idtab,
            "animations":self.animations,
            "building":self.building,
            "banners":self.banners
			]
		if self.propass != nil && self.prologin != nil {
			params["prologin"] = self.prologin!
			params["propass"] = self.propass!
		}
        let _ = PocketAPI.shared.syncSetTask(method: .setSettings , params: params ) { (data) in
            success = String(data: data, encoding: .utf8)?.contains("success") ?? false
        }
        return success
    }
    
}
