//
//  PocketLongActionButton.swift
//  rasp.guap
//
//  Created by Кирилл on 25.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketLongActionButton: PocketButton {
	let indicator: PocketActivityIndicatorView = PocketActivityIndicatorView(frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
		
		self.addSubview(indicator)
		
		indicator.isUserInteractionEnabled = false
		indicator.snp.makeConstraints {
			$0.height.width.equalTo(self.snp.height)
			$0.center.equalToSuperview()
		}
		self.indicator.isHidden = true
		indicator.stopAnimating()
    }
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.addSubview(indicator)
		
		indicator.isUserInteractionEnabled = false
		indicator.snp.makeConstraints {
			$0.height.width.equalTo(self.snp.height)
			$0.center.equalToSuperview()
		}
		self.indicator.isHidden = true
		indicator.stopAnimating()
	}

    override func setupView() {
		super.setupView()
		indicator.color = self.titleLabel?.textColor ?? .gray
    }
	
	func disable() {
		self.isActive = false
		self.indicator.isHidden = false
		self.titleLabel?.layer.opacity = 0
		self.imageView?.layer.opacity = 0
		self.indicator.startAnimating()
	}
	func enable() {
		self.isActive = true
		self.titleLabel?.layer.opacity = 1
		self.imageView?.layer.opacity = 1
		self.indicator.stopAnimating()
	}

}
