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
        self.titleLabel?.textAlignment = .center
    }
    func setupSizeConstraints(){
        self.snp.removeConstraints()
        self.titleLabel?.snp.removeConstraints()
        self.snp.makeConstraints { (make) in
            make.height.equalTo(22)
        }
        self.titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(8)
        })
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupView()
    }

}
