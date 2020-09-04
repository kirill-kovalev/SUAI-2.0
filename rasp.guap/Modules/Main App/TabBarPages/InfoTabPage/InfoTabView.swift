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
		
		view.allowsLinkPreview = false
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
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		updateWebViewColors()
	}
	func updateWebViewColors(){
		func jsRGB(color:UIColor)->String{
			let color = CIColor(color: color)
			return "\"rgb(\(Int(color.red*255)),\(Int(color.green*255)),\(Int(color.blue*255))\""
		}
		let background = Asset.PocketColors.pocketWhite.color
		
		webView.evaluateJavaScript("""
			document.getElementById('bm-v').style.backgroundColor = \(jsRGB(color: background))
			var children = document.getElementById('bm-v').children
			for(i in children){
				child = children[i]
				if(child.children != undefined ){
					if (child.children[0].children[0] != undefined){
						child.children[0].children[0].style.fill = \(jsRGB(color: background))
						if (child.children[0].children[0].children[0] != undefined){
							child.children[0].children[0].children[0].style.fill = \(jsRGB(color: background))
						}
					}
				}
			}
			
			
		""", completionHandler: nil)
	}
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
