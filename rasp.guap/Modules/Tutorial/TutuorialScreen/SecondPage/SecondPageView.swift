//
//  SecondPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class SecondPageView: TutorialPageView{
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
//    override func setupConstraints(){
//        
//
//        imageView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.width.equalTo(imageView.snp.height).multipliedBy(imageView.image!.size.width/imageView.image!.size.height)
//            make.height.lessThanOrEqualTo(imageView.image!.size.height)
//            make.width.height.equalToSuperview().multipliedBy(0.8).priority(.high)
//        }
//        
//
//        //super.setupConstraints()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
