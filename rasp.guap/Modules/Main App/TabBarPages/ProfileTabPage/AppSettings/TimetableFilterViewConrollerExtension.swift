//
//  TimetableFilterViewConrollerExtension.swift
//  rasp.guap
//
//  Created by Кирилл on 04.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

extension TimetableFilterViewConroller{
	func hidePreps(){
		self.content.prepField.isHidden = true
		self.content.preplabel.isHidden = true
		self.content.prepField.snp.removeConstraints()
		self.content.prepField.snp.makeConstraints { (make) in
			make.top.equalTo(self.content.groupField.snp.bottom)
			make.bottom.equalTo(self.content.selector.snp.top)
		}
	}
}
