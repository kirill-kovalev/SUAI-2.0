//
//  GetTaskByID.swift
//  SUAI_API
//
//  Created by Кирилл on 13.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public extension ProGuap{
	func getDetailedTask(id:Int) -> ProTask.Detailed?{
		var headers:[String:String] = [:]
		headers["Cookie"] = self.AUTH_COOKIE
		headers["Sec-Fetch-Mode"] = "cors"

		let semaphore = DispatchSemaphore(value: 0)
		var task:ProTask.Detailed? = nil
		Self.POST("https://pro.guap.ru/get-student-task/\(id)", params: [:], headers: headers) { (data, resp, err) in
			if let data = data {
				task = self.decodeDetailedTasks(data)
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
