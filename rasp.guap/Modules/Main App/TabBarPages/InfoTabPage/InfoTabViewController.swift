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
//		self.rootView.webView.uiDelegate = self
		self.rootView.webView.navigationDelegate = self
		self.rootView.webView.isHidden = true
		self.rootView.webView.backgroundColor = self.rootView.backgroundColor
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.rootView.indicator.startAnimating()
		updateWebView()
	}
	func loadWebView(darkMode:Bool = false){
		if let url = URL(string: "https://suaipocket.ru/info\(darkMode ? "#dark" : "#light")"){
			print("WEB: loading with url \(url)")
			let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15	)
			if let _ = self.rootView.webView.load(request){
				print("WEB: load returned object")
			}else{
				print("WEB: load returned nil")
			}
		}
		
		
	}
	func updateWebView(){
		self.rootView.notReleasedLabel.isHidden = true
		self.rootView.webView.backgroundColor = self.rootView.backgroundColor
		if #available(iOS 12.0, *) {
			if traitCollection.userInterfaceStyle == .dark {
				loadWebView(darkMode: true)
			}else {
				loadWebView(darkMode: false)
			}
		} else {
			// Fallback on earlier versions
			loadWebView(darkMode: false)
		}
	}
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		updateWebView()
	}
	
	
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension InfoTabViewController:WKNavigationDelegate{
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		
		print("WEB: loaded url \(webView.url)")
		if let url = webView.url {
			URLSession.shared.dataTask(with: url) { (data, response, err) in
				let resp = (response as! HTTPURLResponse)
				if resp.statusCode == 200 {
					DispatchQueue.main.async {
						self.rootView.webView.isHidden = false
						self.rootView.indicator.stopAnimating()
					}
				}else{
					DispatchQueue.main.async {
						self.rootView.indicator.stopAnimating()
						self.rootView.notReleasedLabel.isHidden = false
					}
				}
			}.resume()
		}
	}
	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		self.rootView.notReleasedLabel.isHidden = false
		print("WEB: failed nav \(navigation!) wit err \(error)")
	}
}
//extension InfoTabViewController:WKUIDelegate{
//
//}
