//
//  PocketLongActionButton.swift
//  rasp.guap
//
//  Created by Кирилл on 25.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketLongActionButton: PocketButton {
	let indicator:PocketActivityIndicatorView = PocketActivityIndicatorView(frame: .zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
		self.addSubview(indicator)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
		self.addSubview(indicator)
    }

    override func setupView(){
		super.setupView()
		indicator.color = self.titleLabel?.textColor ?? .gray
		indicator.frame = self.frame
		indicator.setNeedsLayout()
		indicator.layoutIfNeeded()
		
    }
	
	func disable(){
		self.isActive = false
		self.titleLabel?.isOpaque = true
		self.imageView?.isOpaque = true
		self.indicator.startAnimating()
	}
	func enable(){
		self.isActive = false
		self.titleLabel?.isOpaque = false
		self.imageView?.isOpaque = false
		self.indicator.startAnimating()
	}
    

}
