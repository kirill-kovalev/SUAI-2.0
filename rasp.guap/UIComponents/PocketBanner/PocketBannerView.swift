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
        label.font = FontFamily.TTCommons.bold.font(size: 22)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
    private let subtitle:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        return label
    }()
    private let button:PocketLongActionButton = {
        let btn = PocketLongActionButton(frame: .zero)
        btn.titleLabel?.font = FontFamily.SFProDisplay.bold.font(size: 14)
        btn.setTitleColor(Asset.PocketColors.buttonOutlineBorder.color, for: .normal)
		btn.borderWidth = 0
        btn.backgroundColor = Asset.PocketColors.pocketBlue.color
        btn.layer.cornerRadius = 10
        btn.layoutMargins = .init(top: 7, left: 15, bottom: 7, right: 15)
        btn.titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(7)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-7)
            make.right.equalToSuperview().offset(-15)
        })
        return btn
    }()
    private let image:UIImageView = {
        let view = UIImageView(frame: .zero)
		view.contentMode = .scaleAspectFill
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
			make.top.equalToSuperview().offset(4)
			make.left.equalToSuperview()
            make.right.equalTo(image.snp.left).offset(-10)
        }
        subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.left.equalTo(title)
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(subtitle.snp.bottom).offset(8)
            make.left.equalTo(subtitle)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        image.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(11)
            make.width.equalTo(image.snp.height)
			make.height.lessThanOrEqualTo(self.snp.width).dividedBy(3)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(11)
        }
    }
    public func setButton(title:String,action: @escaping (Button) -> Void ){
        self.button.setTitle(title, for: .normal)
        self.button.addTarget(action: action, for: .touchUpInside)
    }
}
