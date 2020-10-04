//
//  FeedOrderSettingsHeader.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FeedOrderSettingsHeader:UIStackView{
	let title:UILabel = {
		let label = UILabel(frame: .zero)
		return label
	}()
	let text:UILabel = {
		let label = UILabel(frame: .zero)
		return label
	}()
	init() {
		super.init(frame: .zero)
		self.axis = .vertical
		self.addArrangedSubview(title)
		self.addArrangedSubview(text)
	}
	
	required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
