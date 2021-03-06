//
//  User.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import SwiftyVK

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
	
	public var vkName:String?
	public var vkPhoto:String?
    
	public static var shared = fromServer() ?? fromCache() ?? SAUserSettings();
    
	private init(){
		self.idtab = 1
		self.animations = 1
		self.building = 1
		self.banners = 1
	}
	private func getVk(){
		struct vkResponse:Codable{
            let last_name: String
            let first_name: String
			let photo_100:String
        }
        
		guard let data = try? VK.API.Users.get([.fields:"photo_100"]).synchronously().send(),
			let resp = try? JSONDecoder().decode([vkResponse].self, from: data),
			let user = resp.first
			else { return }
		self.vkName = "\(user.first_name) \(user.last_name)"
		self.vkPhoto = user.photo_100
	}
	
    private static func fromServer() -> SAUserSettings?{
        if let data = PocketAPI.shared.syncLoadTask(method: .getSettings) { 
            do{
                let settings = try JSONDecoder().decode(SAUserSettings.self, from: data)
				settings.getVk()
				settings.saveToCache()
				return settings
            }catch{
                print("Settings Server: \(error)")
            }
        }
		return nil
    }
    private static func fromCache() -> SAUserSettings?{
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
	private func saveToCache(){
		if let data = try? JSONEncoder().encode(self){
			UserDefaults.standard.set(data, forKey: "\(Self.self)" )
		}
	}
	public func reset(){
		self.group = nil
		self.prologin = nil
		self.propass = nil
		self.procookie = nil
		UserDefaults.standard.removeObject(forKey: "\(Self.self)")
	}
    
    public func reload() -> Bool{
        guard let settings = SAUserSettings.fromServer() else{  return false}
        self.group = settings.group
        self.idtab = settings.idtab
        self.animations = settings.animations
        self.building = settings.building
        self.banners = settings.banners
		self.prologin = settings.prologin
		self.propass = settings.propass
		self.vkName = settings.vkName
		self.vkPhoto = settings.vkPhoto
		return true
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
        if let data = PocketAPI.shared.syncSetTask(method: .setSettings , params: params ) { 
            success = String(data: data, encoding: .utf8)?.contains("success") ?? false
        }
        return success
    }
    
}
