//
//  TabBarPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TabBarPageView : View, UIScrollViewDelegate{
    let header:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Asset.PocketColors.headerBackground.color
        return view
    }()
    private let title : UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.TTCommons.bold.font(size: 24)
        label.numberOfLines = 1
        label.text = "Title"
        return label
    }()
    private let scroll:UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.showsHorizontalScrollIndicator = false
        //view.layer.masksToBounds = false
        return view
    }()
    private let container:UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    private func addViews(){
        super.addSubview(header)
        header.addSubview(title)
        
        
        super.addSubview(scroll)
        scroll.addSubview(container)
        
        scroll.delegate = self
    }
    override func addSubview(_ view: UIView) {
        self.container.addSubview(view)
    }
    
    private func setupConstraints(){
        header.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).offset(35)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.top).offset(65)
            make.left.right.equalToSuperview()
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        
        scroll.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom).inset(30)
            make.left.right.bottom.equalToSuperview()
            
        }
        container.snp.makeConstraints { (make) in
            make.width.equalTo(scroll.frameLayoutGuide)
            make.top.equalTo(scroll.contentLayoutGuide).offset(30)
            make.bottom.equalTo(scroll.contentLayoutGuide).inset(10)
            //make.top.bottom.equalTo(scroll.safeAreaLayoutGuide)
            //make.top.equalToSuperview()
        }
    }
    
    func setTitle(_ title:String) {
        self.title.text = title
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
        print(scrollView.contentOffset.y)
    }
}
