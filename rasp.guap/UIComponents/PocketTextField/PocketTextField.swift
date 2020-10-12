//
//  PocketTextField.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketTextField: UITextField {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupView()
	}
	
	func setupView() {
		self.font = FontFamily.SFProDisplay.regular.font(size: 14)
		self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
		self.leftViewMode = .always
		self.layer.cornerRadius = 10
		self.backgroundColor = Asset.PocketColors.pocketLightGray.color
		self.textRect(forBounds: self.bounds.insetBy(dx: 5, dy: 5))
		self.doneAccessory = true
		traitCollectionDidChange(nil)
		self.snp.removeConstraints()
		self.snp.makeConstraints {$0.height.equalTo(40)}
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		self.layer.borderColor = Asset.PocketColors.pocketGray.color.withAlphaComponent(0.4).cgColor
		self.layer.borderWidth = 1
	}
	
}
