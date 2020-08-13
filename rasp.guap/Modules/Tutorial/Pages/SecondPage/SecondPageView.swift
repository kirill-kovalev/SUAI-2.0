//
//  SecondPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class SecondPageView: TutorialPageView{
    
    // MARK: - Views
    
    let newsFirst:PocketNewsView = PocketNewsView()
    let newsSecond:PocketNewsView = PocketNewsView()
    
    lazy var divFirst:PocketDivView<PocketNewsView> = {return PocketDivView(content: newsFirst) }()
    lazy var divSecond:PocketDivView<PocketNewsView> = {return PocketDivView(content: newsSecond) }()
    
    
    // MARK: - View setup
    
    required init() {
        super.init()
        
        setupUI()
        addViews()
        setupConstraints()
    }
    
    override func addViews() {
        super.addViews()
        self.addSubview(divFirst)
        self.addSubview(divSecond)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        divFirst.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(12)
            make.bottom.equalTo(self.snp.centerY).inset(10)
        })
        divSecond.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(12)
            make.top.equalTo(self.snp.centerY).offset(10)
        })
    
    }
    
    private func setupUI(){
        self.title.text = "Новости"
        self.text.text = "Будь в курсе всех событий \nуниверситета и секций"
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
