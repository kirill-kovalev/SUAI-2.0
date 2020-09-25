//
//  PocketTagButton.swift
//  rasp.guap
//
//  Created by Кирилл on 09.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketTagButton: PocketButton {
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

    override func setupView(){
        let borderColor = self.isActive ? Asset.PocketColors.accent.color : Asset.PocketColors.pocketTagBorder.color
        self.backgroundColor = self.isActive ? Asset.PocketColors.pocketBlue.color : Asset.PocketColors.pocketLightGray.color
        let textColor = self.isActive ? Asset.PocketColors.accent.color : Asset.PocketColors.pocketGray.color
        self.layer.borderColor = borderColor.cgColor
        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = 7
        self.titleLabel?.font = FontFamily.SFProDisplay.regular.font(size: 14)
        self.titleLabel?.textAlignment = .center
    }
    private func setupSizeConstraints(){
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

}
