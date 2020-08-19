//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class InfoTabView:TabBarPageView {
    let webView:UIWebView = {
        let view = UIWebView(frame: .zero)
        view.loadRequest(URLRequest(url: URL(string: "https://ya.ru")!))
        return view
    }()
    
    required init() {
        super.init()
        super.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(self.header.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
