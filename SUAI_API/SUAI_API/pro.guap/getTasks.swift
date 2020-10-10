//
//  getTasks.swift
//  SUAI_API
//
//  Created by Кирилл on 10.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public extension ProGuap{
	func getTasks() -> [ProTask]?{
		if let user = self.user,
		   let id = user.user_id{
			var headers : [String:String] = [:]
			headers["Cookie"] = self.AUTH_COOKIE
			headers["Sec-Fetch-Mode"] = "cors"
			
			var params:[String:String] = [:]
			params["iduser"] = id
			params["role"] = "1"
			params["tid"] = "0"
			params["offset"] = "0"
			params["limit"] = "15"

			var deadlines:[ProTask] = []
			let semaphore = DispatchSemaphore(value: 0)
			Self.POST("https://pro.guap.ru/get-student-tasksdictionaries/", params: params, headers: headers) { (data, resp, err) in
				if let data = data,
				   let decoded = self.decodeDeadlines(data){
					deadlines = decoded
				}
				semaphore.signal()
			}
			let _ = semaphore.wait(timeout: .distantFuture)
			
			return deadlines
		}
		return nil
	}
	private func decodeDeadlines(_ data:Data) -> [ProTask]?{
		
		struct ProGuapDeadlinesResponse:Codable{
			let tasks:[ProTask]
		}
		
		
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(formatter)
		
		do{
			let response = try decoder.decode(ProGuapDeadlinesResponse.self, from: data)
			return response.tasks
		}catch{
			print(error)
		}
		return nil
		
//		return response?.tasks
	}
}
