//
//  SADeadlines.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SADeadlines{
	public static let shared = SADeadlines()
	
	public var nearest:[SADeadline] {
		return self.open.filter { (deadline) -> Bool in
			return deadline.type == .nearest
		}
	}
	public var open:[SADeadline]{
		return self.deadlines.filter { (d) -> Bool in
			return d.type != .closed
		}
	}
	public var closed:[SADeadline]{
		return self.deadlines.filter { (d) -> Bool in
			return d.type == .closed
		}
	}
	
	private var deadlines = [SADeadline]()
	
	public func loadFromServer(){
		let _ = PocketAPI.shared.syncLoadTask(method: .getDeadlines ) { (data) in
			do {
				self.deadlines = try self.decodeDeadlines(data: data )
			}catch{
				print("Deadlines: \(error)")
			}
		}
	}
	
	private func decodeDeadlines(data:Data) throws  -> [SADeadline] {
		let decoder = JSONDecoder()
		
		decoder.dateDecodingStrategy = .formatted(SADeadline.formatter)
		return try decoder.decode([SADeadline].self, from: data)
	}
	
	
	
	public func close(deadline: SADeadline) -> Bool {
		var success = false
		let _ = PocketAPI.shared.syncSetTask(method: .closeDeadline, params: ["id":deadline.id]) { (data) in
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		self.loadFromServer()
		return success
	}
	
	public func reopen(deadline: SADeadline) -> Bool {
		var success = false
		let _ = PocketAPI.shared.syncSetTask(method: .openDeadline, params: ["id":deadline.id]) { (data) in
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		self.loadFromServer()
		return success
	}
	
	public func create(deadline: SADeadline) -> Bool {
		
		var success = false
		let _ = PocketAPI.shared.syncSetTask(method: .createDeadline, params: [
																		"deadline_name":deadline.deadline_name ?? "name",
																		"subject_name":deadline.subject_name ?? "",
																		"start":deadline.startDate,
																		"end":deadline.endDate,
																		"comment":deadline.comment,
		]) { (data) in
			//print(String(data: data, encoding: .utf8))
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		self.loadFromServer()
		return success
	}
	public func edit(deadline: SADeadline) -> Bool{
		var success = false
		let _ = PocketAPI.shared.syncSetTask(method: .editDeadline, params: [
																	"id":deadline.id,
																	"deadline_name":deadline.deadline_name ?? "name",
																	"subject_name":deadline.subject_name ?? "",
																	"start":deadline.startDate,
																	"end":deadline.endDate,
																	"comment":deadline.comment
		]) { (data) in
			//print(String(data: data, encoding: .utf8))
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		self.loadFromServer()
		return success
	}
	public func delete(deadline: SADeadline) -> Bool{
		var success = false
		let _ = PocketAPI.shared.syncSetTask(method: .deleteDeadline, params: ["id":deadline.id]) { (data) in
			success = String(data: data, encoding: .utf8)?.contains("success") ?? false
		}
		self.loadFromServer()
		return success
	}
	
	
	
}





