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
    let select:Button = {
        let button = Button(frame: .zero)
        button.setTitle("Выбрать", for: .normal)
        button.setTitleColor(Asset.PocketColors.pocketDarkestBlue.color, for: .normal)
        button.titleLabel?.font = FontFamily.SFProDisplay.bold.font(size: 24)
        return button
    }()
    
    let button:Button = {
        let button = Button(frame: .zero)
        button.setTitle("Продолжить", for: .normal)
        button.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
        button.titleLabel?.font = FontFamily.SFProDisplay.regular.font(size: 14)
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
            make.bottom.equalTo(self.button.snp.top).inset(-30)
            make.centerX.equalToSuperview()
        }
        self.button.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
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
