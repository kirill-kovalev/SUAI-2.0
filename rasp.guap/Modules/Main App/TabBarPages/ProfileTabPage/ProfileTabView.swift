//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ProfileTabView:TabBarPageView {
	lazy var scroll:UIScrollView = {
		let scroll = UIScrollView(frame: .zero)
		
		return scroll
	}()
	lazy var stack:UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
	required init(){
        super.init()
        addViews()
        setupConstraints()
    }
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	func addViews(){
		self.addSubview(scroll)
        scroll.addSubview(self.stack)
    }
    func setupConstraints(){
		scroll.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(12)
			make.left.right.equalToSuperview()
			make.bottom.equalTo(self.safeAreaLayoutGuide)
		}
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(scroll.contentLayoutGuide)
			make.bottom.lessThanOrEqualTo(scroll.contentLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
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
	
	
	
}
