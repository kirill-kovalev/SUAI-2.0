//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import WebKit


class InfoTabView:TabBarPageView {
    let webView:WKWebView = {
        let view = WKWebView(frame: .zero)
		let color = CIColor(color: Asset.PocketColors.pocketWhite.color)
		view.allowsLinkPreview = false
		view.evaluateJavaScript("document.body.style.backgroundColor = 'rgb(\(Int(color.red*255)),\(Int(color.green*255)),\(Int(color.blue*255))'", completionHandler: nil)
        return view
    }()
	let indicator:UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(frame: .zero)
		indicator.hidesWhenStopped = true
		indicator.startAnimating()
		return indicator
	}()
    
    required init() {
        super.init()
        super.addSubview(webView)
		super.addSubview(indicator)
		title.snp.makeConstraints { $0.bottom.equalToSuperview()}
		header.backgroundColor = .clear
		self.bringSubviewToFront(self.header)
        webView.snp.makeConstraints { (make) in
            //make.top.equalTo(self.header.snp.bottom)
			make.top.equalTo(self)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview()
        }
		indicator.snp.makeConstraints{$0.center.equalToSuperview()}
		
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
