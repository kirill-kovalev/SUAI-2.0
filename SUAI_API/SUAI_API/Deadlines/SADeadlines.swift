//
//  SADeadlines.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SADeadlines{
	private var sync = 0
	
	public static let shared = SADeadlines()
	
	public var nearest:[SADeadline] {
		return self.open.filter { (deadline) -> Bool in
			return deadline.type == .nearest
		}
	}
	public var open:[SADeadline]{
		return self.deadlines.filter { (d) -> Bool in
			return d.type != .closed && d.type != .pro
		}
	}
	public var closed:[SADeadline]{
		return self.deadlines.filter { (d) -> Bool in
			return d.type == .closed
		}
	}
	public var pro:[SADeadline]{
		return self.deadlines.filter { (d) -> Bool in
			return d.isPro
		}
	}
	public var all:[SADeadline]{
		return self.deadlines
	}
	
	private var deadlines = [SADeadline]()
	private var lastUpdate = Date()
	private var needUpdate:Bool {Date().timeIntervalSince(self.lastUpdate) > 60}
	
	
	
	private var userDefaultsKey:String {"\(Self.self)Cache"}
	public func loadFromServer() -> Bool{
		while self.sync > 0 {}
		self.sync += 1
		let params : [String:String] = (SAUserSettings.shared.proSupport) ? ["need_proguap":"True"] : [:]
		if let data = PocketAPI.shared.syncLoadTask(method: .getDeadlines ,params:params ) {
			self.sync -= 1
			
			do {
				self.deadlines = try self.decodeDeadlines(data: data )
				if SAUserSettings.shared.proSupport,self.pro.isEmpty { self.loadPro() } // Если у Дани сломаются дедлайны, тянем сразу из гуапа
				self.lastUpdate = Date()
				UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
				return true
			}catch{
				print("Deadlines: \(error)")
			}
		}
		if SAUserSettings.shared.proSupport,self.pro.isEmpty { self.loadPro() } // Если у Дани сломаются дедлайны, тянем сразу из гуапа

		self.sync -= 1
		return false
	}
	private func loadPro(){
		if !ProGuap.shared.needsToAuth,
			ProGuap.shared.getUser() != nil,
			let tasks = ProGuap.shared.getTasks()
		{
			let deadlines = tasks.compactMap { task -> SADeadline? in
				guard let id = Int(task.id) else {return nil}
				var deadline = SADeadline(id: id, subject_name: task.subject_name, deadline_name: task.name, closed: 0, start: task.datecreate, end: Date(), comment: task.description)
				
				
				deadline.end = task.dateend
				
				deadline.status_name = task.status_name
				deadline.type_name = task.type_name
				deadline.markpoint = task.markpoint
				deadline.is_our = 0
				
				
				return deadline
			}
			self.deadlines.append(contentsOf: deadlines)
		}else{
			print("LOADPRO: needs to auth \(ProGuap.shared.needsToAuth)")
			print("LOADPRO: used \(ProGuap.shared.getUser()as Any)")
		}
	}
	
	public func loadFromCache(){
		if let data = UserDefaults.standard.data(forKey: self.userDefaultsKey){
			do {
				self.deadlines = try self.decodeDeadlines(data: data )
			}catch{
				print("Deadlines.loadFromCache: \(error)")
			}
		}
		
	}
	
	private func decodeDeadlines(data:Data) throws  -> [SADeadline] {
		let decoder = JSONDecoder()
		
		decoder.dateDecodingStrategy = .formatted(SADeadline.formatter)
		return try decoder.decode([SADeadline].self, from: data)
	}
	
	func index(deadline: SADeadline)->Int?{
		for (i,d) in self.deadlines.enumerated(){
			if d.id == deadline.id{return i}
		}
		return nil
	}
	
	public func close(deadline: SADeadline) -> Bool {
		while self.sync > 0 {}
		self.sync += 1
		
		guard let index:Int = index(deadline: deadline) else {return false}
		self.deadlines[index].closed = 1
		
		var success = false
		if let data = PocketAPI.shared.syncSetTask(method: .closeDeadline, params: ["id":deadline.id]) {
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		if !success {self.deadlines[index].closed = 0}
		self.sync -= 1
		return success && self.loadFromServer()
	}
	
	public func reopen(deadline: SADeadline) -> Bool {
		while self.sync > 0 {}
		self.sync += 1
		
		guard let index:Int = index(deadline: deadline) else {return false}
		self.deadlines[index].closed = 0
		
		var success = false
		if let data = PocketAPI.shared.syncSetTask(method: .openDeadline, params: ["id":deadline.id]) {
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		if !success {self.deadlines[index].closed = 1}
		self.sync -= 1
		return success && self.loadFromServer()
	}
	
	public func create(deadline: SADeadline) -> Bool {
		while self.sync > 0 {}
		self.sync += 1
		
		
		var success = false
		if let data = PocketAPI.shared.syncSetTask(method: .createDeadline, params: [
																		"deadline_name":deadline.deadline_name ?? "name",
																		"subject_name":deadline.subject_name ?? "",
																		"start":deadline.startDate,
																		"end":deadline.endDate,
																		"comment":deadline.comment,
		]) {
			//print(String(data: data, encoding: .utf8))
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		self.sync -= 1
		return success && self.loadFromServer()
	}
	public func edit(deadline: SADeadline) -> Bool{
		while self.sync > 0 {}
		self.sync += 1
		
		var success = false
		guard let index:Int = index(deadline: deadline) else {return false}
		let old = self.deadlines[index]
		self.deadlines[index] = deadline
		if let data = PocketAPI.shared.syncSetTask(method: .editDeadline, params: [
																	"id":deadline.id,
																	"deadline_name":deadline.deadline_name ?? "name",
																	"subject_name":deadline.subject_name ?? "",
																	"start":deadline.startDate,
																	"end":deadline.endDate,
																	"comment":deadline.comment
		]) {
			//print(String(data: data, encoding: .utf8))
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		if !success {self.deadlines[index] = old}
		if needUpdate { let _ = self.loadFromServer()}
		self.sync -= 1
		return success && self.loadFromServer()
	}
	public func delete(deadline: SADeadline) -> Bool{
		while self.sync > 0 {}
		self.sync += 1
		
		var success = false
		if let data = PocketAPI.shared.syncSetTask(method: .deleteDeadline, params: ["id":deadline.id]) { 
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		if success {self.deadlines = self.deadlines.filter{$0.id != deadline.id} }
		
		self.sync -= 1
		return success && self.loadFromServer()
	}
	
	
	
}





