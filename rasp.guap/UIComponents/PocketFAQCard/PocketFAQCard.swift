//
//  FAQCard.swift
//  rasp.guap
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketFAQCard: View {
    let image: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.image = Asset.AppImages.FAQImages.inst.image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
    }
    init(title: String, image: UIImage) {
        super.init()
        addViews()
        self.image.image = image
        self.label.text = title
        setupConstraints()
    }
    
    func addViews() {
        self.addSubview(image)
        self.addSubview(label)
    }
    func setupConstraints() {
        label.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        image.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(label.snp.top)
            make.width.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
