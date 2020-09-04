//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import WebKit
import ESTabBarController_swift

class InfoTabViewController: ViewController<InfoTabView> {
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: "Справочник", image: Asset.AppImages.TabBarImages.info.image, tag: 3)
		self.keyboardReflective = false
    }
    
    override func viewDidLoad() {
        self.rootView.setTitle(self.tabBarItem.title ?? "")
		self.rootView.webView.navigationDelegate = self
		self.rootView.webView.load(URLRequest(url: URL(string: "http://sputnik.guap.ru/nav/")!))
		
    }
	
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension InfoTabViewController:WKNavigationDelegate{
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		self.rootView.indicator.stopAnimating()
		self.rootView.updateWebViewColors()
		webView.evaluateJavaScript("document.getElementById('block_menu').remove()", completionHandler: nil)
	}
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("failed nav \(navigation) wit err \(error)")
	}
}
