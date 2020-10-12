//
//  PocketAvatar.swift
//  rasp.guap
//
//  Created by Кирилл on 02.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketUserAvatar: UIView {
    var color: UIColor = .clear {
        didSet {
            self.layer.borderColor = self.color.cgColor
        }
    }
    let imageView: UIImageView = {
        let img = UIImageView(frame: .zero)
        img.layer.masksToBounds = true
        img.image = Asset.AppImages.photoPlaceholder.image
        return img
    }()
    init() {
        super.init(frame: .zero)
        self.addSubview(imageView)
        
        self.layer.borderWidth = 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
        let size = self.bounds.size
        let inset: CGFloat = 5
        self.imageView.frame = CGRect(x: inset, y: inset, width: size.width - inset*2, height: size.height - inset*2)
        self.imageView.layer.cornerRadius = self.imageView.bounds.size.height/2
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layer.borderColor = self.color.cgColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
