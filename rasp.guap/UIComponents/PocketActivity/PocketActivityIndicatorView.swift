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
	var isAnimating:Bool = false
	
	private var radius:CGFloat{
		if self.frame.height > self.frame.width{
			return self.frame.width/2 - 10
		}else{
			return self.frame.height/2 - 10
		}
	}
	
	lazy var rotationLayer = CALayer()
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
		self.layer.addSublayer(rotationLayer)
		layer.addSublayer(circleLayer)
	}
	convenience init(style:UIActivityIndicatorView.Style){
		self.init(frame:.zero)
	}
	
	
	
	func startAnimating() {
		layoutIfNeeded()
		let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
		self.circleLayer.path = UIBezierPath(arcCenter: center, radius: self.radius, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true).cgPath
		show()
		self.layer.add(rotateAnimation, forKey: "rotationAnimation")
		self.isAnimating = true
	}
	func stopAnimating() {
		hide()
		let transform = self.rotationLayer.presentation()?.transform
		self.rotationLayer.removeAnimation(forKey: "rotationAnimation")
		self.rotationLayer.transform = transform ?? CATransform3D()
		self.isAnimating = false
	}
	func show(){
		circleLayer.add(showAnimation, forKey: "showAnimation")
	}
	func hide(){
		circleLayer.add(hideAnimation, forKey: "hideAnimation")
	}
}


class TestVC:UIViewController{

	
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
	

	@objc func tap(_ sender:Any?){
		print("tap")
		if self.v.isAnimating {
			self.v.stopAnimating()
		}else{
			self.v.startAnimating()
		}
	}
	
}
//class PocketActivityIndicatorView:UIActivityIndicatorView{
//	override func draw(_ rect: CGRect) {
//
//	}
//}
