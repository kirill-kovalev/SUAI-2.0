//
//  Logger.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

class Logger {
	public static var log: String = UserDefaults.standard.string(forKey: "Logger.log") ?? ""
	static func print(_ items: Any?...) {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "Ru")
		formatter.dateFormat = "YY/M/dd hh:mm:ss"
		
		let date = formatter.string(from: Date())
		let string = "LOGGER - [\(date)] : \(items) \n____________________________________________________________________________________________________\n\n"
		log += string 
		prnt(log: string)

	}
	static func print(from: Any, _ items: Any?...) {
		Logger.print("\(from.self) \n \(items)")
	}
	static func save() {
		UserDefaults.standard.synchronize()
		UserDefaults.standard.removeObject(forKey: "Logger.log")
		UserDefaults.standard.set(self.log, forKey: "Logger.log")
	}
}
private func prnt(log: Any?) {
	if let log = log {
		print(log)
	}
}

func fatalError(_ message: String) -> Never {
	Logger.print(from: "FATAL ERROR", message)
	Logger.save()
	fatalError()
}
