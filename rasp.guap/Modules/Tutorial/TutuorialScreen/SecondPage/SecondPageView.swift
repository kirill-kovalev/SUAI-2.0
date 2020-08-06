//
//  SecondPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class SecondPageView: TutorialPageView{
    
    // MARK: - View setup
    
    required init() {
        super.init()
        setupUI()
        addViews()
        setupConstraints()
    }
    
    private func setupUI(){
        self.title.text = "Новости"
        self.text.text = "Будь в курсе всех событий \nуниверситета и секций"
        self.imageView.image = Asset.AppImages.TutorialPreview.news.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
