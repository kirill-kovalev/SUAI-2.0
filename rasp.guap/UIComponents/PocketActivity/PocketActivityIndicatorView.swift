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
	var color: UIColor = .gray {
		didSet {
			self.circleLayer.strokeColor = color.cgColor
		}
	}
	var hidesWhenStopped: Bool = true
	var isAnimating: Bool = false
	
	private var radius: CGFloat {
		if self.frame.height > self.frame.width {
			return self.frame.width/2 - 10
		} else {
			return self.frame.height/2 - 10
		}
	}
	
	lazy var rotationLayer = CALayer()
	lazy var circleLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.strokeColor = self.color.cgColor
		layer.strokeStart = 0
		layer.strokeEnd = 0
		layer.fillColor = UIColor.clear.cgColor
		layer.lineWidth = 3
		layer.lineCap = .round
		return layer
	}()
	lazy var showAnimation: CABasicAnimation = {
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.toValue = 1
		animation.duration = 0.6
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = false
		return animation
	}()
	lazy var hideAnimation: CABasicAnimation = {
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.toValue = -0.1
		animation.duration = 0.3
		animation.fillMode = .forwards
		animation.isRemovedOnCompletion = false
		return animation
	}()
	
	lazy var rotateAnimation: CAAnimation = {
		let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotation.fromValue = 0
		rotation.toValue = 2*Double.pi
		rotation.duration = 1
		rotation.repeatCount = .infinity
		rotation.isRemovedOnCompletion = false
		return rotation
	}()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.layer.addSublayer(rotationLayer)
		layer.addSublayer(circleLayer)
		startAnimating()
	}
	convenience init(style: UIActivityIndicatorView.Style) {
		self.init(frame: .zero)
	}
	
	func startAnimating() {
		self.isHidden = false
		if !self.isAnimating {
			self.isAnimating = true
			circleLayer.add(showAnimation, forKey: "showAnimation")
		}
		self.layer.add(rotateAnimation, forKey: "rotationAnimation")
	}
	
	func stopAnimating() {
		if self.isAnimating {
			if hidesWhenStopped {
				CATransaction.begin()
				CATransaction.setCompletionBlock {
					self.isAnimating = false
					self.layer.removeAnimation(forKey: "rotationAnimation")
				}
				circleLayer.add(hideAnimation, forKey: "hideAnimation")
				CATransaction.commit()
			} else {
				self.isAnimating = false
				self.layer.removeAnimation(forKey: "rotationAnimation")
			}
			
		}
		
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		layoutIfNeeded()
		let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
		self.circleLayer.path = UIBezierPath(arcCenter: center, radius: self.radius, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true).cgPath
	}
}

class TestVC: UIViewController {
	let v = PocketActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let gest = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
		view.addGestureRecognizer(gest)
		view.backgroundColor = .white
		
		self.view.addSubview(v)
		
		v.snp.makeConstraints { (make) in
			make.height.width.equalTo(40)
			make.center.equalToSuperview()
			
		}
		v.startAnimating()
	}

	@objc func tap(_ sender: Any?) {
		if self.v.isAnimating {
			self.v.stopAnimating()
		} else {
			self.v.startAnimating()
		}
	}
	
}
//class PocketActivityIndicatorView:UIActivityIndicatorView{
//	override func draw(_ rect: CGRect) {
//
//	}
//}
