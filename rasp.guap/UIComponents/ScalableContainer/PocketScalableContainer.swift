//
//  PocketScalableContainer.swift
//  rasp.guap
//
//  Created by Кирилл on 08.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketScalableContainer<T:UIView>:Button{
	var content : T
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	init(content:T) {
        self.content = content
		content.isUserInteractionEnabled = false
		content.isExclusiveTouch = false
		super.init(frame:.zero)
		self.addSubview(content)
		self.content.snp.makeConstraints { (make) in
			make.top.left.equalToSuperview()
			make.right.bottom.equalToSuperview()
		}
    }
	@objc private func touchDown(_ sender:Button){
		UIView.animate(withDuration: 0.2) {
			self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
		}
	
	}
	@objc private func touchUp(_ sender:Button){
		UIView.animate(withDuration: 0.2) {
			self.transform = .identity
		}
	}
	override func didMoveToSuperview() {
		superview?.didMoveToSuperview()
		self.addTarget(self, action: #selector(touchUp(_:)), for: .touchUpInside)
		self.addTarget(self, action: #selector(touchUp(_:)), for: .touchUpOutside)
		self.addTarget(self, action: #selector(touchUp(_:)), for: .touchCancel)
		self.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
	}
	
	
}


