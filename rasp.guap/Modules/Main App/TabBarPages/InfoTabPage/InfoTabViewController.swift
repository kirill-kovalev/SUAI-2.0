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
		self.tabBarItem.image?.accessibilityValue = Asset.AppImages.TabBarImages.info.name
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
			Logger.print(from: #function, "WEB: loading with url \(url)")
			let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15	)
			if let _ = self.rootView.webView.load(request){
				Logger.print(from: #function, "WEB: load returned object")
			}else{
				Logger.print(from: #function, "WEB: load returned nil")
			}
		}
		
		
	}
	func updateWebView(){
//		self.rootView.indicator.startAnimating()
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
		updateColorScheme()
		
	}
	func updateColorScheme(){
		if #available(iOS 12.0, *) {
			let scheme = traitCollection.userInterfaceStyle == .dark ? "client_dark" : "client_light"
			self.rootView.webView.evaluateJavaScript("document.body.setAttribute('scheme','\(scheme)')", completionHandler: nil)
		}
	}
	
	
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension InfoTabViewController:WKNavigationDelegate{
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		
		Logger.print(from: #function, "WEB: loaded url \(webView.url as Any)")
		if let url = webView.url {
			URLSession.shared.dataTask(with: url) { (data, response, err) in
				
				if let resp = (response as? HTTPURLResponse),
				resp.statusCode == 200 {
					DispatchQueue.main.async {
						self.rootView.webView.isHidden = false
						self.rootView.notReleasedLabel.isHidden = true
						self.rootView.indicator.stopAnimating()
						self.updateColorScheme()
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
		Logger.print(from: #function, "WEB: failed nav \(navigation!) wit err \(error)")
	}
}

