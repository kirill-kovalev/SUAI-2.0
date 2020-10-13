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
	
	public var vkName:String? {
		get{
			if vkFirstName == nil && vkLastName == nil { return nil}
			return "\(vkFirstName ?? "") \(vkLastName ?? "")"
		}
	}
	public var vkFirstName:String?
	public var vkLastName:String?
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
        
		guard
			!VK.needToSetUp,
			let data = try? VK.API.Users.get([.fields:"photo_100"]).synchronously().send(),
			let resp = try? JSONDecoder().decode([vkResponse].self, from: data),
			let user = resp.first else {
			print("Logger (\(#function): can't get VK profle info");
			return
		}
		self.vkFirstName = "\(user.first_name)"
		self.vkLastName = "\(user.last_name)"
		self.vkPhoto = user.photo_100
	}
	
    private static func fromServer() -> SAUserSettings?{
        if let data = PocketAPI.shared.syncLoadTask(method: .getSettings) { 
            do{
                let settings = try JSONDecoder().decode(SAUserSettings.self, from: data)
				settings.getVk()
				settings.saveToCache()
				if let proLogin =  settings.prologin,
					let proPass = settings.propass {
					let _ = ProGuap.shared.auth(login: proLogin, pass: proPass)
				}
				return settings
            }catch{
                print("Settings Server: \(error)")
            }
        }
		return nil
    }
    private static func fromCache() -> SAUserSettings?{
        guard let data = UserDefaults.standard.data(forKey: "\(Self.self)" ) else {return nil }
        do{
            return try JSONDecoder().decode(SAUserSettings.self, from: data)
        }catch{
            print("Settings Cache: \(error)")
            return nil
        }
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
		self.vkFirstName = settings.vkFirstName
		self.vkLastName = settings.vkLastName
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
			if !success {
				self.propass = nil
				self.prologin = nil
				self.procookie = nil
			}
        }
        return success
    }
    
}
