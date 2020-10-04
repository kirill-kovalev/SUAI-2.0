//
//  SuaiIDView.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class SuaiIDView: View {
	let proguap:UILabel = {
		let label = UILabel(frame: .zero)
		label.text = "pro.guap"
		label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
		label.textColor = Asset.PocketColors.pocketBlack.color
		return label
	}()
	
	let emailTF:UITextField = {
		let tf = PocketTextField(frame: .zero)
		tf.placeholder = "Электронная почта"
		return tf
	}()
	let passTF:UITextField = {
		let tf = PocketTextField(frame: .zero)
		tf.placeholder = "Пароль"
		tf.isSecureTextEntry = true
		return tf
	}()
	let submitBtn:PocketLongActionButton = {
		let btn = PocketLongActionButton()
		btn.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
		btn.setTitleColor(Asset.PocketColors.pocketGray.color, for: .disabled)
		btn.isActive = false
		btn.setTitle("Сохранить данные", for: .normal)
		btn.snp.removeConstraints()
		return btn
	}()
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init() {
		super.init()
		addViews()
		setupConstraints()
	}
	
	func addViews(){
		self.addSubview(proguap)
		self.addSubview(emailTF)
		self.addSubview(passTF)
		self.addSubview(submitBtn)
	}
	func setupConstraints(){
		proguap.snp.makeConstraints { $0.top.right.left.equalToSuperview() }
		emailTF.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(proguap.snp.bottom).offset(12)
		}
		passTF.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(emailTF.snp.bottom).offset(12)
			
		}
		
		submitBtn.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(passTF.snp.bottom).offset(12)
			make.height.equalTo(40)
			make.bottom.equalToSuperview()
		}
	}
	

}
