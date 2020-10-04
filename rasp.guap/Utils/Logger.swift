//
//  Logger.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

class Logger{
	public static var log:String = ""
	static func print(_ items:Any?...){
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "Ru")
		formatter.dateFormat = ""
		
		let date = formatter.string(from: Date())
		let string = "\n[\(date)] : \(items) \n\n___________________________________________________________________________________________\n\n"
		log.append(string)
		debugPrint(string)
	}
	static func print(from:Any,_ items:Any?...){
		Logger.print("\(from.self) \n \(items)")
	}
}



