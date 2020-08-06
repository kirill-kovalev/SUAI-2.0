//
//  FourthPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FourthPageView : TutorialPageView{
   
    
    required init() {
        super.init()
        setupText()
        addViews()
        setupConstraints()
    }
    private func setupText(){
        self.imageView.image = Asset.AppImages.TutorialPreview.timetable.image
        self.title.text = "Расписание"
        self.text.text = "Смотри расписание преподавателей и \nгрупп в реальном времени"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
