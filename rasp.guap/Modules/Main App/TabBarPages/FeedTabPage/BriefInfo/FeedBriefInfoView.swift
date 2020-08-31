//
//  FeedBriefInfoView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class FeedBriefInfoView: UIScrollView {
    private var loadIndicator = UIActivityIndicatorView(frame: .zero)
    
    lazy var stack:UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        return stack
    }()
    lazy var indicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    init(){
        super.init(frame:.zero)
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
            make.center.equalToSuperview()
        }
        stack.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(frame:.zero)
    }
}
