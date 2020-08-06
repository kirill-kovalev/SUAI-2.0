//
//  GroupSelectPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class GroupSelectPageView:TutorialPageView{
    
    
    
    
    required init() {
        super.init()
        setupUI()
        addViews()
        setupConstraints()
    }
    private func setupUI(){
        
        self.title.text = "Начнем?"
        self.text.text = "Выбери свою группу и нажми “Продолжить”"
    }
    override func addViews(){
        super.addViews()
        
    }
    override func setupConstraints(){
        super.setupConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
