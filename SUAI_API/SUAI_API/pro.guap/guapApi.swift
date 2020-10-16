//
//  guapApi.swift
//  SUAI_API
//
//  Created by Кирилл on 09.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class ProGuap{
	private static let defaultHeaders:[String:String] = {
		var defaultHeaders:[String:String] = [:]
		defaultHeaders["Sec-Fetch-Site"] = "same-origin"
		defaultHeaders["Accept-Encoding"] = "gzip, deflate, br"
		defaultHeaders["Host"] = "pro.guap.ru"
		defaultHeaders["Sec-Fetch-Mode"] = "navigate"
		defaultHeaders["Sec-Fetch-User"] = "?1"
		defaultHeaders["Accept-Language"] = "ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7"
		defaultHeaders["Sec-Fetch-Dest"] = "document"
		defaultHeaders["Content-Type"] = "application/x-www-form-urlencoded"
		defaultHeaders["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.116 Safari/537.36 OPR/67.0.3575.130"
		defaultHeaders["Accept"] = "*/*"
		defaultHeaders["Connection"] = "keep-alive"
		defaultHeaders["Upgrade-Insecure-Requests"] = "1"
		return defaultHeaders
	}()
	
	private class RedirectPrevent:NSObject,URLSessionTaskDelegate{
		func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
			completionHandler(nil)
		}
	}
	private static let redirectPrevent = RedirectPrevent()
	static func Request(_ url:String,
						method:String,
						params:[String:String] = [:],
						headers:[String:String] = [:],
						completion: @escaping ((Data?, HTTPURLResponse?, Error?) -> Void)){
		
		var request = URLRequest(url: URL(string: url)!)
		request.httpMethod = method
		
		request.httpBody = params.map({ (key,value) in
			let queryKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
			let queryValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
			return queryKey+"="+queryValue
		}).joined(separator: "&").data(using: .utf8)
		
		
		var configHeaders = defaultHeaders
		for (key,val) in headers {
			configHeaders[key] = val
		}
		
		
		request.allHTTPHeaderFields = configHeaders
		request.httpShouldHandleCookies = true
		print("""
			[\(url)]_________________________________________________
			METHOD : "\(request.httpMethod ?? "nil")"
			Headers : \(request.allHTTPHeaderFields ?? [:])
			Params : \(String(data:request.httpBody ?? Data(),encoding: .utf8) ?? "nil")
			___________________________________________________________________________________
			""")
		
		let config = URLSessionConfiguration.default
		
		URLSession(configuration: config, delegate: redirectPrevent, delegateQueue: nil).dataTask(with: request){ (data, resp, err) in
			completion(data,resp as? HTTPURLResponse,err)
		}.resume()
	}
	
	
	internal static func GET(_ url:String,
			 params:[String:String] = [:],
			 headers:[String:String] = [:],
			 completion: @escaping ((Data?, HTTPURLResponse?, Error?) -> Void)){
		
			Request(url, method: "GET", params: params, headers: headers, completion: completion)
		
	}

	internal static func POST(_ url:String,
			  params:[String:String] = [:],
			  headers:[String:String] = [:],
			  completion: @escaping ((Data?, HTTPURLResponse?, Error?) -> Void)){
		
		Request(url, method: "POST", params: params, headers: headers, completion: completion)
	}
	
	
	public static let shared = ProGuap()
	
	var AUTH_COOKIE:String? = nil
	public var needsToAuth:Bool {AUTH_COOKIE == nil}
	var user:GuapUser? = nil
	
	init(){
		self.AUTH_COOKIE = UserDefaults.standard.value(forKey: "ProGuapPhpCookie") as? String
	}

	
}
