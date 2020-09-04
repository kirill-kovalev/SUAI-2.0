//
//  GroupSelectPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class GroupSelectPageView:TutorialPageView{
    
    // MARK: - Views
    let select:PocketTextField = {
        let tf = PocketTextField(frame: .zero)
		tf.placeholder = "М611"
		let image = UIImageView(image: Asset.SystemIcons.searchDropdown.image.withRenderingMode(.alwaysTemplate))
		image.tintColor = Asset.PocketColors.pocketGray.color
		image.snp.makeConstraints {$0.size.equalTo(CGSize(width: 30, height: 30))}
		tf.rightViewMode = .always
		tf.rightView = image
        return tf
    }()
    
    let button:PocketTagButton = {
        let button = PocketTagButton(frame: .zero)
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
        button.titleLabel?.font = FontFamily.SFProDisplay.regular.font(size: 14)
		button.isActive = false
        return button
    }()
    
    
    // MARK: - View setup
    
    required init() {
        super.init()
        setupUI()
        addViews()
        setupConstraints()
    }
    override func addViews() {
        super.addViews()
        
        self.addSubview(button)
        self.addSubview(select)
    }
    override func setupConstraints() {
        super.setupConstraints()
        self.select.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.button.snp.top).inset(-20)
            make.centerX.equalToSuperview()
			make.width.equalTo(250)
        }
		self.button.snp.removeConstraints()
        self.button.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
			make.width.equalTo(select)
			make.height.equalTo(40)
        }
    }
    
    private func setupUI(){
        self.title.text = "Начнем?"
        self.text.text = "Выбери свою группу и нажми “Продолжить”"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
