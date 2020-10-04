//
//  AboutUsView.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class AboutUsView:View{
	let image:UIImageView = {
		let view = UIImageView(frame: .zero)
		view.layer.masksToBounds = true
		view.layer.cornerRadius = 10
		view.image = UIImage(named: "AppIconLight")
		return view
	}()
	lazy var imageContainer = PocketScalableContainer(content: image)
	required init() {
		super.init()
		addViews()
		setupConstraints()
	}
	func addViews(){
		self.addSubview(imageContainer)
		
	}
	func setupConstraints(){
		imageContainer.snp.makeConstraints { (make) in
			make.top.left.bottom.equalToSuperview()
			make.width.height.equalTo(55)
		}
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
