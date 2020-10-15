//
//  GetTaskByID.swift
//  SUAI_API
//
//  Created by Кирилл on 13.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public extension ProGuap{
	
	fileprivate var defaultsKeyID:String {"ProGuapTaskCacheID"}
	fileprivate var defaultsKeyDate:String {"ProGuapTaskCacheDate"}
	
	fileprivate func saveToCache(detailedTask task:ProTask.Detailed){
		print("CACHE: saving task \(task.id)")
		if let encoded = try? JSONEncoder().encode(task){
			UserDefaults.standard.setValue(encoded, forKey: defaultsKeyID+task.id)
			UserDefaults.standard.setValue(Date(), forKey: defaultsKeyDate+task.id)
			print("CACHE: saved task \(task.id)")
		}
	}
	fileprivate func getFromCache(detailedTaskID id:Int)->ProTask.Detailed? {
		print("CACHE: loading task \(id)")
		if let data = UserDefaults.standard.value(forKey: defaultsKeyID+"\(id)") as? Data,
			let date = UserDefaults.standard.value(forKey: defaultsKeyDate+"\(id)") as? Date,
			date.addingTimeInterval(3600*24*7) > Date(),
			let decoded = try? JSONDecoder().decode(ProTask.Detailed.self, from: data)
		{
			print("CACHE: loaded task \(id)")
			return decoded
		}
		return nil
	}
	
	func getDetailedTask(id:Int) -> ProTask.Detailed?{
		
		if let fromCache = getFromCache(detailedTaskID: id){
			return fromCache
		}
		
		var headers:[String:String] = [:]
		headers["Cookie"] = self.AUTH_COOKIE
		headers["Sec-Fetch-Mode"] = "cors"
		
		let semaphore = DispatchSemaphore(value: 0)
		var task:ProTask.Detailed? = nil
		Self.POST("https://pro.guap.ru/get-student-task/\(id)", params: [:], headers: headers) { (data, resp, err) in
			if let data = data {
				task = self.decodeDetailedTasks(data)
				if let task = task {
					self.saveToCache(detailedTask: task)
				}
			}
			
			semaphore.signal()
		}
		let _ = semaphore.wait(timeout: .distantFuture)
		return task
	}
	private func decodeDetailedTasks( _ data:Data) -> ProTask.Detailed?{
		
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(formatter)
		
		struct _Task : Codable { let task:[ProTask.Detailed] }
		do{
			return try decoder.decode(_Task.self, from: data).task.first
		}catch{
			print("Error: \(error)")
		}
		return nil
	}
}
