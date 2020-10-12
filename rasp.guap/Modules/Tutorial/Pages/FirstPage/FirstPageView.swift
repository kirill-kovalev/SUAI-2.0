//
//  FirstPage.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FirstPageView: TutorialPageView {
    // MARK: - Views
    
    private let gestureZone: UIView = {
        let view = UIView(frame: .zero)
        
        return view
    }()
    
    let tapGesture: UITapGestureRecognizer = {
        let gesture =  UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        return gesture
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - View setup
    
    required init() {
        super.init()
        setupUI()
        addViews()
        setupConstraints()
        self.gestureZone.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        self.imageView.image = Asset.AppImages.pocketpocketLogo.image
        self.title.text = "Добро пожаловать!"
        
        let attributedString = NSMutableAttributedString(string: "тапни сюда", attributes: [
            NSAttributedString.Key.foregroundColor: Asset.PocketColors.accent.color
        ])
        let text = NSMutableAttributedString(string: "Свайпни влево, если хочешь узнать \nособенности сервиса, или ")
        text.append(attributedString)
        text.append(NSMutableAttributedString(string: ",\n чтобы сразу перейти к выбору группы"))
        self.text.attributedText = text
    }
    
    override func addViews() {
        super.addViews()
        
        self.addSubview(imageView)
        self.addSubview(gestureZone)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            let imageHeight: CGFloat = imageView.image?.size.height ?? 1
            let imageWidth: CGFloat = imageView.image?.size.width ?? 0
            make.width.equalTo(imageView.snp.height).multipliedBy(imageWidth/imageHeight)
            make.height.lessThanOrEqualTo(imageHeight)
            make.size.lessThanOrEqualToSuperview()
            make.width.height.lessThanOrEqualToSuperview().multipliedBy(0.8).priority(.high)
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
