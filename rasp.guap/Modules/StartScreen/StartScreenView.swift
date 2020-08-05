//
//  StartScreenView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import iOSDropDown

class StartScreenView: MainView {
    
    
    let pagedView = PagedView()

    func addViews() {
        self.addSubview(pagedView)
        for i in 0..<colors.count {
            let v = UIView(frame: .zero)
            v.backgroundColor = colors[i]
            pagedView.addSubview(v)
        }
    }
    
    var colors:[UIColor] = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow]
    
    func setupConstraints() {
        self.pagedView.snp.makeConstraints { (make) in
            make.width.height.left.top.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    
    required init() {
        super.init()
        self.backgroundColor = .magenta
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


