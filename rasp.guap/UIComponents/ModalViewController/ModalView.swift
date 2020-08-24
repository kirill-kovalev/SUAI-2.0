//
//  ModalView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ModalView: View {
    
    static let hiddenTransform: CGAffineTransform = {
        let positionTransform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        let scaleTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        return scaleTransform.concatenating(positionTransform)
    }()
    
    let container:UIView = {
        let container = UIView();
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.backgroundColor = Asset.PocketColors.pocketWhite.color
        container.layer.cornerRadius = 10
        
        container.transform = ModalView.hiddenTransform
        return container;
    }()
    
    let header:UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let closeButton:Button = {
        let btn = Button(frame: .zero)
        btn.setImage(Asset.SystemIcons.modalViewExitCross.image, for: .normal)
        return btn
    }()
    let titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.text = "title"
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    
    

    required init() {
        super.init()
        self.backgroundColor = .black
        self.backgroundColor = self.backgroundColor!.withAlphaComponent(0.6)
        addViews()
        setupConstraints()
    }
    
    func setContent(_ contentView:UIView){
        container.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func addViews(){
        self.addSubview(container)
        container.addSubview(header)
        header.addSubview(closeButton)
        header.addSubview(titleLabel)
    }
    
    private func setupConstraints(){
        container.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-20)
            //make.height.greaterThanOrEqualToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        header.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        closeButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.trailing.top.equalToSuperview().inset(15)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.centerY.equalTo(closeButton.snp.centerY)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
