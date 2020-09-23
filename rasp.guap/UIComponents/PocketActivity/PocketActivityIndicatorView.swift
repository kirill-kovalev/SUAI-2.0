//
//  PocketActivityIndicatorView.swift
//  rasp.guap
//
//  Created by Кирилл on 23.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

@IBDesignable
class PocketActivityIndicatorView: UIView {
	var color : UIColor = .gray {
		didSet{
			self.circleLayer.strokeColor = color.cgColor
		}
	}
	var hidesWhenStopped: Bool = true
	
	private var radius:CGFloat{
		if self.frame.height > self.frame.width{
			return self.frame.width/2 - 10
		}else{
			return self.frame.height/2 - 10
		}
	}
	

	lazy var circleLayer:CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.strokeColor = self.color.cgColor
		layer.strokeStart = 0
		layer.strokeEnd = 0
		layer.fillColor = UIColor.clear.cgColor
		layer.lineWidth = 5
		layer.lineCap = .round
		return layer
	}()
	lazy var showAnimation:CABasicAnimation = {
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.toValue = 1
		animation.duration = 1
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = false
		return animation
	}()
	lazy var hideAnimation:CABasicAnimation = {
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.toValue = -0.1
		animation.duration = 0.5
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = false
		return animation
	}()
	
	lazy var rotateAnimation:CAAnimation = {
		let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotation.fromValue = 0
		rotation.toValue = 2*Double.pi
		rotation.duration = 1
		rotation.repeatCount = .infinity
		return rotation
	}()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.addSublayer(circleLayer)
	}
	
	
	func startAnimating() {
		show()
		self.layer.add(rotateAnimation, forKey: "rotationAnimation")
	}
	func stopAnimating() {
		hide()
		let transform = self.layer.presentation()?.transform
		self.layer.removeAnimation(forKey: "rotationAnimation")
		self.layer.transform = transform ?? self.layer.transform
	}
	func show(){
		circleLayer.add(showAnimation, forKey: "showAnimation")
	}
	func hide(){
		circleLayer.add(hideAnimation, forKey: "hideAnimation")
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		self.circleLayer.path = UIBezierPath(arcCenter: self.center, radius: self.radius, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true).cgPath
	}
}
