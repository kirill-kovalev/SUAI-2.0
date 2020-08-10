//
//  FirstScreenView.swift
//  AirrouteApp
//
//  Created by Кирилл on 30.07.2020.
//  Copyright © 2020 kirill-kovalev. All rights reserved.
//

import UIKit

class FirstScreenView: View {
    
    // MARK: - Views
    
    let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ""
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
    
    let btn :Button = {
        let btn = Button(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Show", for: .normal)
        btn.setTitleColor(Asset.PocketColors.pocketBlack.color, for: .normal)
        return btn;
    }()
    
    let btn2 :Button = {
        let btn = Button(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Go", for: .normal)
        btn.setTitleColor(Asset.PocketColors.pocketBlack.color, for: .normal)
        return btn;
    }()
    
    let btn3 :Button = {
        let btn = Button(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Alert", for: .normal)
        btn.setTitleColor(Asset.PocketColors.pocketBlack.color, for: .normal)
        return btn;
    }()
    
    let textInput:UITextField =  {
        let field = UITextField(frame: .zero)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let pocketDiv: PocketDivView = {
        let news = UIView(frame: .zero)
        let div = PocketDivView(content: news )
        return div
    }()
    
    // MARK: - View setup
    required init() {
        super.init()
        self.backgroundColor = Asset.PocketColors.pocketWhite.color
        
        addViews()
        setupConstraints()
    }
    
    private func addViews(){
        self.addSubview(label)
        self.addSubview(btn)
        self.addSubview(btn2)
        //self.addSubview(btn3)
        self.addSubview(pocketDiv)
        
    }
    
    private func setupConstraints(){
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: btn, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: btn2, attribute: .top, relatedBy: .equal, toItem: btn, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: btn2, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        ])
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: btn3, attribute: .top, relatedBy: .equal, toItem: btn2, attribute: .bottom, multiplier: 1, constant: 10),
//            NSLayoutConstraint(item: btn3, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
//        ])
        
        pocketDiv.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.leftMargin.rightMargin.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
