//
//  TabBarPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TabBarPageView : View{
    let header:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Asset.PocketColors.headerBackground.color
        return view
    }()
    let title : UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.TTCommons.bold.font(size: 22)
        label.numberOfLines = 1
        label.text = "Title"
        return label
    }()

    private let container:UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    private let buttonContainer:UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        return stack
    }()
    
    private func addViews(){
        super.addSubview(header)
        header.addSubview(title)
        header.addSubview(buttonContainer)
        
        
        super.addSubview(container)
        
    }
    override func addSubview(_ view: UIView) {
        self.container.addSubview(view)
    }
    
    private func setupConstraints(){
        header.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.centerX.equalToSuperview()
			make.bottom.lessThanOrEqualToSuperview()
        }
        buttonContainer.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(title.snp.centerY)
            make.right.lessThanOrEqualTo(title.snp.left).inset(10)
        }
        
        
        container.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func setTitle(_ title:String) {
        self.title.text = title
    }
    func addHeaderButton(_ btn:UIButton){
        self.buttonContainer.addArrangedSubview(btn)
    }
    
    required init() {
        super.init()
        self.backgroundColor = Asset.PocketColors.backgroundPage.color
        addViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("did scroll")
    }
}
