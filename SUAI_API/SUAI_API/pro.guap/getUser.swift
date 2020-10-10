//
//  getUser.swift
//  SUAI_API
//
//  Created by Кирилл on 10.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public extension ProGuap{
	
	func getUser() -> GuapUser? {
		var headers : [String:String] = [:]
		headers["Cookie"] = self.AUTH_COOKIE
		headers["Referer"] = "https://pro.guap.ru/inside_s"
		headers["Host"] = "pro.guap.ru"
		headers["Sec-Fetch-Dest"] = "empty"
		headers["Sec-Fetch-Mode"] = "cors"
		headers["Sec-Fetch-Site"] = "same-origin"
		headers["X-Requested-With"] = "XMLHttpRequest"
		
		var stringResponse:String = ""
		let semaphore = DispatchSemaphore(value: 0)
		Self.GET("https://pro.guap.ru/inside_s", params: [:], headers: headers) { (data, resp, err) in
			stringResponse = String(data:data ?? Data(),encoding: .utf8) ?? ""
			semaphore.signal()
		}
		let _ = semaphore.wait(timeout: .distantFuture)
		
		if let user = GuapUser.parse(stringResponse) {
			self.user = self.user ?? user
			return user
		}
		return self.user
		
	}
}
