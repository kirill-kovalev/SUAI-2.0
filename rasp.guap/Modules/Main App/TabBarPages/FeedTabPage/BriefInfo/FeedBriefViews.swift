//
//  FeedBriefViws.swift
//  rasp.guap
//
//  Created by Кирилл on 01.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class BriefHalfScreenView: UIView {
    init(title: String, subtitle: String = "", image: UIImage, color: UIColor? = nil) {
        super.init(frame: .zero)
        self.title.text = title
        self.subtitle.text = subtitle
        if color != nil {
            self.image.image = image.withRenderingMode(.alwaysTemplate)
            self.image.tintColor = color
        } else {
            self.image.image = image
        }
        
        addViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
    let title: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.TTCommons.bold.font(size: 22)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
    let subtitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        return label
    }()
    let image: UIImageView = {
        let view = UIImageView(frame: .zero)
        
        return view
    }()
    private func addViews() {
        self.addSubview(title)
        self.addSubview(subtitle)
        self.addSubview(image)
    }
    private func setupConstraints() {
        image.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(40)

        }
        title.snp.makeConstraints { (make) in
            make.left.equalTo(image.snp.right).offset(10)
            make.centerY.equalTo(image)
        }
        subtitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(image.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
    }
}
