//
//  FirstPage.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FirstPageView:MainView{
    private let image: UIImageView = {
        let image = Asset.AppImages.pocketpocketLogo
        let imageView = UIImageView(image: image.image)
        return imageView
    }()
    private let title:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Добро пожаловать!"
        label.textAlignment = .center
        label.font = FontFamily.TTCommons.demiBold.font(size: 22)
        return label
    }()
    private let text:UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = Asset.PocketColors.pocketGray.color
        let attributedString = NSMutableAttributedString(string: "тапни сюда", attributes: [
            NSAttributedString.Key.foregroundColor : Asset.PocketColors.accent.color
        ])
        let text = NSMutableAttributedString(string: "Свайпни влево, если хочешь узнать \nособенности сервиса или ")
        text.append(attributedString)
        text.append(NSMutableAttributedString(string: ",\n чтобы сразу перейти к выбору группы"))
        label.numberOfLines = 3
        label.attributedText = text
        label.font = FontFamily.TTCommons.regular.font(size: 18)
        return label
    }()
    private let gestureZone:UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    let tapGesture :UITapGestureRecognizer = {
        let gesture =  UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        return gesture
    }()
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
        self.gestureZone.addGestureRecognizer(tapGesture)
        
    }
    private func addViews(){
        self.addSubview(image)
        self.addSubview(title)
        self.addSubview(text)
        self.addSubview(gestureZone)
    }
    private func setupConstraints(){
        image.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(image.image?.size ?? .zero)
        }
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.bottom).dividedBy(1.25)
        }
        text.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
       }
        gestureZone.snp.makeConstraints { (make) in
            make.trailing.bottom.top.equalTo(text)
            make.leading.equalTo(text.snp.centerX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
