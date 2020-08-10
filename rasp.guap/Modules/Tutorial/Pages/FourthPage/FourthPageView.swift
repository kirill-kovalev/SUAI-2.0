//
//  FourthPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FourthPageView : TutorialPageView{
    
    // MARK: - Views
    let tableContainer: PocketDivView = PocketDivView()
   
     // MARK: - View setup
    
    required init() {
        super.init()
        setupText()
        addViews()
        setupConstraints()
    }
    
    override func addViews() {
        super.addViews()
        self.addSubview(tableContainer)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        tableContainer.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(12)
        }
    }
    
    private func setupText(){
        self.title.text = "Расписание"
        self.text.text = "Смотри расписание преподавателей и \nгрупп в реальном времени"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
