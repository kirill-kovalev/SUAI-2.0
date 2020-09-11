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
//		let url = URL(string: "http://sputnik.guap.ru/nav/")!
//		let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10	)
		//self.rootView.webView.load(request)
		
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.rootView.updateWebViewColors()
		self.rootView.indicator.startAnimating()
		self.rootView.webView.isHidden = true
	}
	
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension InfoTabViewController:WKNavigationDelegate{
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		DispatchQueue.main.asyncAfter(deadline: .now()+1) {
			self.rootView.indicator.stopAnimating()
			webView.isOpaque = false
			self.rootView.updateWebViewColors()
			webView.evaluateJavaScript("document.getElementById('block_menu').remove()", completionHandler: nil)
		}
	}
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("failed nav \(navigation!) wit err \(error)")
	}
}
