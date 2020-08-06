//
//  ThirdPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ThirdPageView : TutorialPageView{
   
     // MARK: - View setup
    
    required init() {
        super.init()
        setupText()
        addViews()
        setupConstraints()
    }
    
    private func setupText(){
        self.imageView.image = Asset.AppImages.TutorialPreview.deadline.image
        self.title.text = "Дедлайны"
        self.text.text = "Контролируй учебный процесс, ставь \nзадачи и выполняй их в срок"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
