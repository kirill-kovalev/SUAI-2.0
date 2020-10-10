//
//  auth.swift
//  SUAI_API
//
//  Created by Кирилл on 10.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public extension ProGuap{
	func auth(login:String, pass:String) -> Bool{
		let semaphore = DispatchSemaphore(value: 0)
		var success = false
		Self.GET("https://pro.guap.ru/exters/") { (data, resp, err) in
			if let resp = resp,
			   let cookie = (resp.allHeaderFields["Set-Cookie"] as? String)?.split(separator: ";").first{
				let sesCookie = String(cookie)
				print(sesCookie)
				let params:[String:String] = [
					"_username":login,
					"_password":pass
				]
				
				
				Self.POST("https://pro.guap.ru/user/login_check", params: params, headers: ["Cookie":sesCookie]) { (data, resp, err) in
					if let resp = resp,
					   let cookie = (resp.allHeaderFields["Set-Cookie"] as? String)?.split(separator: ";").first{
						self.AUTH_COOKIE = String(cookie)
						UserDefaults(suiteName: "pro_guap")?.setValue(self.AUTH_COOKIE, forKey: "phpCookie")
						success = true
					}
					semaphore.signal()
				}
				
				
			}else{
				semaphore.signal()
			}
			
		}
		let _ = semaphore.wait(timeout: .distantFuture)
		return success
	}
}
