//
//  PocketButton.swift
//  rasp.guap
//
//  Created by Кирилл on 25.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketButton: Button {
    var isActive:Bool = false {
        didSet{
            self.isEnabled = self.isActive
            setupView()
        }
    }
	
	var borderWidth:CGFloat = 1
	var cornerRadius:CGFloat = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
	
    
    func setupView(){
		
		
		self.titleLabel?.font = FontFamily.SFProDisplay.semibold.font(size: 13)
		let color = self.titleLabel?.textColor ?? .blue
        
		self.layer.cornerRadius = self.cornerRadius
		self.layer.borderWidth = self.borderWidth
        
        self.imageView?.tintColor = color
        self.layer.borderColor = color.cgColor
    }
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		self.addTarget(self, action: #selector(touchUp(_:)), for: .touchUpInside)
		self.addTarget(self, action: #selector(touchUp(_:)), for: .touchUpOutside)
		self.addTarget(self, action: #selector(touchUp(_:)), for: .touchCancel)
		self.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
		setupView()
	}
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupView()
    }

	@objc private func touchDown(_ sender:Button){
		UIView.animate(withDuration: 0.1) {
			self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
		}
	}
	@objc private func touchUp(_ sender:Button){
		UIView.animate(withDuration: 0.1) {
			self.transform = .identity
		}
	}

}
