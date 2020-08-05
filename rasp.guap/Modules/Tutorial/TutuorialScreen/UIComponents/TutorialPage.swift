//
//  TutorialPage.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TutorialPage<Content:UIView>: UIView {
    private let content = Content()
    
    let title:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Заголовок"
        label.textColor = .red
        return label
    }()
    
    let text:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "текст"
        label.textColor = .red
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        addViews()
        setupConstrints()
    }
    
    private func addViews(){
        self.addSubview(content)
        self.addSubview(title)
        self.addSubview(text)
    }
    
    private func setupConstrints(){
        content.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.lessThanOrEqualToSuperview().dividedBy(3)
        }
        title.snp.makeConstraints { (make) in
            make.width.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.centerY)//.multipliedBy(3/4)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
