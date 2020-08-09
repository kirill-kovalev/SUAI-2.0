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
    }
    override func setupConstraints() {
        super.setupConstraints()
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
