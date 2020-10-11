//
//  PocketDayView.swift
//  rasp.guap
//
//  Created by Кирилл on 09.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketDayView: NibView {

	@IBOutlet weak var lessonType: UILabel?
	
	@IBOutlet weak var title: UILabel!
    @IBOutlet weak var lessonNum: UILabel!
    @IBOutlet weak var prep: UILabel!
    @IBOutlet weak var verticalLine: UIView!
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var tagStack: UIStackView!
}
