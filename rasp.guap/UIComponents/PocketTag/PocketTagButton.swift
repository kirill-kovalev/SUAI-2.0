//
//  PocketTagButton.swift
//  rasp.guap
//
//  Created by Кирилл on 09.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketTagButton: Button {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSizeConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupSizeConstraints()
    }
    
    func setupView(){
        self.layer.borderColor = Asset.PocketColors.pocketTagBorder.color.cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(Asset.PocketColors.pocketTagBorder.color, for: .normal)
        self.layer.cornerRadius = 7
        self.titleLabel?.font = FontFamily.SFProDisplay.regular.font(size: 14)
    }
    func setupSizeConstraints(){
        self.snp.makeConstraints { (make) in
            make.height.equalTo(22)
            make.width.equalTo(self.titleLabel!.snp.width).offset(20)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupView()
    }

}
