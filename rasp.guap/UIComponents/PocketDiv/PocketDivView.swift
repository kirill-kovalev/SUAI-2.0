//
//  PocketDivView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketDivView<T:UIView> : View {
    
    var content : T
    var contentMask:UIView = {
        let v = UIView(frame: .zero)
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 10
        return v
    }()
    
    
    required init() {
        self.content = T(frame: .zero);
        super.init()
        
        setupView()
        super.addSubview(contentMask)
        contentMask.addSubview(content)
        setupConstraints()
    }
    
    override func addSubview(_ view: UIView) {
        self.content.addSubview(view)
    }
    
    
    required init(content:T) {
        self.content = content
        super.init()
        
        setupView()
        super.addSubview(contentMask)
        contentMask.addSubview(content)
        setupConstraints()

    }
    
    private func setupView(){
        
        self.backgroundColor = Asset.PocketColors.pocketWhite.color
        
        self.layer.cornerRadius = 10
        
        self.layer.borderColor = Asset.PocketColors.pocketDivBorder.color.cgColor
        self.layer.borderWidth = 1
        
        
        self.layer.shadowColor = Asset.PocketColors.pocketShadow.color.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupView()
    }
    
    /// TODO: сделать комбинирование теней
    
    private func setupCombinedShadows() {
        super.layoutSubviews()
        
        let shadow1 = CALayer()
        
        shadow1.shadowColor = Asset.PocketColors.pocketLightShadow.color.cgColor
        shadow1.shadowRadius = 5
        shadow1.shadowOpacity = 1
        
        shadow1.masksToBounds = false
        shadow1.frame = self.layer.frame
        
        let shadow2 = CALayer()
        shadow2.shadowColor = Asset.PocketColors.pocketShadow.color.cgColor
        shadow2.shadowRadius = 15
        shadow2.shadowOffset = .zero
        
        shadow2.masksToBounds = false
        //shadow2.frame = self.frame
        
        
        
        self.layer.masksToBounds = false
        self.layer.addSublayer(shadow1)
        self.layer.addSublayer(shadow2)
    }
    
    private func setupConstraints(){
        self.contentMask.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        self.content.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(12)
            make.right.bottom.equalToSuperview().inset(12)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
//
//extension CALayer {
//    func applySketchShadow(
//        color: UIColor = .black,
//        alpha: Float = 0.5,
//        x: CGFloat = 0,
//        y: CGFloat = 2,
//        blur: CGFloat = 4,
//        spread: CGFloat = 0)
//    {
//        shadowColor = color.cgColor
//        shadowOpacity = alpha
//        shadowOffset = CGSize(width: x, height: y)
//        shadowRadius = blur / 2.0
//        if spread == 0 {
//            shadowPath = nil
//        } else {
//            let dx = -spread
//            let rect = bounds.insetBy(dx: dx, dy: dx)
//            shadowPath = UIBezierPath(rect: rect).cgPath
//        }
//        masksToBounds = false
//    }
//}
