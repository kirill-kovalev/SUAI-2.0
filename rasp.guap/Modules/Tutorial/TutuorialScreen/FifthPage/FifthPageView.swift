//
//  FifthPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FifthPageView : TutorialPageView{
   
     // MARK: - View setup
    
    required init() {
        super.init()
        setupText()
        addViews()
        setupConstraints()
    }
    
    private func setupText(){
        self.imageView.image = Asset.AppImages.TutorialPreview.info.image
        self.title.text = "Справочник"
        self.text.text = "Находи всю важную информацию об \nуниверситете и не только"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
