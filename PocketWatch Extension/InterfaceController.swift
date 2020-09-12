//
//  InterfaceController.swift
//  PocketWatch Extension
//
//  Created by Кирилл on 12.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class InterfaceController: WKInterfaceController {
	@IBOutlet weak var table: WKInterfaceTable!
	
	var lessons:[[String]] {
		get { _lessons}
		set{
			_lessons = newValue
			print("lessons did set")
			self.updateTable()
		}
	}
	var _lessons:[[String]] = []
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		if let payload = UserDefaults.standard.data(forKey: "timetable"){
			do{
				self.lessons =  try JSONDecoder().decode([[String]].self, from: payload)
			}catch{print(error)}
			
		}
		if WCSession.isSupported(){
			let session = WCSession.default
			session.delegate = self
			session.activate()
			decodeFromContext(applicationContext: WCSession.default.applicationContext)
		}
        // Configure interface objects here.
    }
	
	override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
		let lesson = self.lessons[rowIndex]
		print(lesson)
		return lesson
	}
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		WCSession.default.sendMessage(["":""], replyHandler: nil, errorHandler: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
		WCSession.default.sendMessage(["":""], replyHandler: nil, errorHandler: nil)
    }
	
	func updateTable(){
		print(#function)
		self.table.setNumberOfRows(self.lessons.count, withRowType: "shecduleItem")
		for (index,lesson) in self.lessons.enumerated() {
			if let controller = self.table.rowController(at: index) as? TableRowController {
				switch lesson[0] {
					case "Л":
						controller.lessonTypeColor.setColor(UIColor(named: "pocket_purple"))
					case "ЛР":
						controller.lessonTypeColor.setColor(UIColor(named: "pocket_aqua"))
					case "ПР":
						controller.lessonTypeColor.setColor(UIColor(named: "pocket_orange"))
					default:
						controller.lessonTypeColor.setColor(UIColor(named: "pocket_green"))
				}
				controller.LessonNameLabel.setText(lesson[1])
			}else{
				print("cast error")
			}
		}
	}
	func decodeFromContext(applicationContext: [String : Any]){
		if let payload = applicationContext["timetable"] as? Data{
			do{
				UserDefaults.standard.set(payload, forKey: "timetable")
				self.lessons =  try JSONDecoder().decode([[String]].self, from: payload)
			}catch{
				print("JSON: \(error)")
			}
			
		}
	}
	
}

extension InterfaceController:WCSessionDelegate{
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		if let error = error {
            fatalError("Can't activate session with error: \(error.localizedDescription)")
        }
		print("WC Session activated with state: \(activationState.rawValue)")
	}
	func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
		print(#function)
		decodeFromContext(applicationContext: applicationContext)
	}
	
	
}
