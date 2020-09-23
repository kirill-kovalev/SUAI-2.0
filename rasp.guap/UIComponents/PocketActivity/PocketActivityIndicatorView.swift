//
//  PocketActivityIndicatorView.swift
//  rasp.guap
//
//  Created by Кирилл on 23.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketActivityIndicatorView: UIView {
//	var style: UIActivityIndicatorView.Style = .medium
	var hidesWhenStopped: Bool = true
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	
	func startAnimating() {

	}
	func stopAnimating() {

	}
}
//class PocketActivityIndicatorView:UIActivityIndicatorView{
//	override func draw(_ rect: CGRect) {
//		<#code#>
//	}
//}
