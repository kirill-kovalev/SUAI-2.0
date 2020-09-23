//
//  FeedBriefInfoView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class FeedBriefInfoView: UIScrollView {
    
    lazy var stack:UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    lazy var indicator:PocketActivityIndicatorView = {
        let indicator = PocketActivityIndicatorView(frame: .zero)
        indicator.startAnimating()
        return indicator
    }()
    init(){
        super.init(frame:.zero)
        addViews()
        setupConstraints()
    }
    func labelGenerator(title:String)->UILabel{
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.bold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = title
        return label
    }
    func addBlock(title:String?,view:UIView?){
        if title != nil{
            self.stack.addArrangedSubview(labelGenerator(title: title!))
        }
        if view != nil {
            self.stack.addArrangedSubview(view!)
        }
        
    }
    override func addSubview(_ view: UIView) {
        self.stack.addArrangedSubview(view)
    }
    
    func addViews(){
        super.addSubview(indicator)
        super.addSubview(self.stack)
    }
    func setupConstraints(){
        indicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
			make.height.width.equalTo(45)
			make.bottom.lessThanOrEqualTo(self.contentLayoutGuide).offset(-15)
        }
        stack.snp.makeConstraints { (make) in
			make.top.equalTo(self.contentLayoutGuide).offset(0)
            make.bottom.equalTo(self.indicator.snp.top).offset(-15)
            
			make.left.equalTo(self.frameLayoutGuide).offset(10)
            make.right.equalTo(self.frameLayoutGuide).inset(10)
		}
    }
    
    required init?(coder: NSCoder) {
        super.init(frame:.zero)
    }
}
