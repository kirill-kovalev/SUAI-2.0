//
//  ScheduleDetailController.swift
//  SUAIWatch WatchKit Extension
//
//  Created by Кирилл on 12.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import WatchKit
import Foundation

class ScheduleDetailController: WKInterfaceController {
	@IBOutlet weak var lessonNameLabel: WKInterfaceLabel!
	@IBOutlet weak var TimeLabel: WKInterfaceLabel!
	@IBOutlet weak var PrepLabel: WKInterfaceLabel!
	@IBOutlet weak var roomsLabel: WKInterfaceLabel!
	
	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		//[lesson.type.rawValue,lesson.name,"\(lesson.start) – \(lesson.end)",preps]
		if let lesson = context as? [String] {
			lessonNameLabel.setText(lesson.at(1))
			TimeLabel.setText(lesson.at(2))
			PrepLabel.setText(lesson.at(3))
			roomsLabel.setText(lesson.at(4))
		}
	}
}
extension Array {
	func at(_ index: Int) -> Element? {
		if index >= 0 && index < self.count {
			return self[index]
		}
		return nil
	}
}
