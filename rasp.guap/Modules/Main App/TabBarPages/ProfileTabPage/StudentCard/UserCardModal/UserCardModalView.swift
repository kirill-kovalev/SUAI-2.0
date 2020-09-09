//
//  UserCardModalView.swift
//  rasp.guap
//
//  Created by Кирилл on 09.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class UserCardModalView: View {
	let card = PocketCard()
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init(){
		super.init()
		addViews()
		setupConstraints()
	}
	
	private func addViews(){
		self.addSubview(card)
	}
	private func setupConstraints(){
		card.snp.makeConstraints { (make) in
			make.top.left.right.equalToSuperview()
			make.bottom.lessThanOrEqualToSuperview()
		}
	}
}
