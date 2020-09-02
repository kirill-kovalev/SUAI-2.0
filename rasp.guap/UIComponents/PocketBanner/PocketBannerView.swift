//
//  PocketBannerView.swift
//  rasp.guap
//
//  Created by Кирилл on 02.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketBannerView:UIView{
    init(title:String,subtitle:String = "",image:UIImage) {
        super.init(frame:.zero)
        self.title.text = title
        self.subtitle.text = subtitle
        self.image.image = image
        
        addViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(frame:.zero)
    }
    private let title:UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    private let subtitle:UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    private let button:Button = {
        let btn = Button(frame: .zero)
        return btn
    }()
    private let image:UIImageView = {
        let view = UIImageView(frame: .zero)
        
        return view
    }()
    private func addViews(){
        self.addSubview(title)
        self.addSubview(subtitle)
        self.addSubview(button)
        self.addSubview(image)
    }
    private func setupConstraints(){
        title.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalTo(image.snp.left).offset(-10)
        }
        subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(title)
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(subtitle.snp.bottom)
            make.left.equalTo(subtitle)
        }
        
        image.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(11)
            make.width.equalTo(image.snp.height)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(11)
        }
    }
    public func setButton(title:String,action: @escaping (Button) -> Void ){
        self.button.setTitle(title, for: .normal)
        self.button.addTarget(action: action, for: .touchUpInside)
    }
}
