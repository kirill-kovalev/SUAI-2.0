//
//  FifthPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FifthPageView : TutorialPageView{
    
    // MARK: - Views
    
    let cards = [
        PocketFAQCard(title: "Институты и\nфакультеты", image: Asset.AppImages.FAQImages.inst.image),
        PocketFAQCard(title: "Отделы \nуниверситета", image: Asset.AppImages.FAQImages.otd.image),
        PocketFAQCard(title: "Приемная \nкомиссия", image: Asset.AppImages.FAQImages.hat.image),
        PocketFAQCard(title: "Иностранные\nстуденты", image: Asset.AppImages.FAQImages.stu.image)
    ]
    lazy var containers = cards.map { (card)  in
        PocketDivView(content: card)
    }
   
     // MARK: - View setup
    
    required init() {
        super.init()
        setupText()
        addViews()
        setupConstraints()
    }
    
    override func addViews() {
        super.addViews()
        for card in self.containers{
            self.addSubview(card)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        for card in self.containers {
            card.snp.makeConstraints { (make) in
                make.width.equalToSuperview().multipliedBy(0.4)
                make.height.equalTo(card.snp.width).multipliedBy(0.8)
                make.center.equalToSuperview()
            }
        }
    }
    
    private func setupText(){
        self.title.text = "Справочник"
        self.text.text = "Находи всю важную информацию об \nуниверситете и не только"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
