//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import WebKit


class InfoTabView:View {
    let webView:WKWebView = {
        let view = WKWebView(frame: .zero)
		
		view.allowsLinkPreview = false
        return view
    }()
	let indicator:PocketActivityIndicatorView = {
		let indicator = PocketActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		indicator.startAnimating()
		return indicator
	}()
	let notReleasedLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = FontFamily.TTCommons.bold.font(size: 24)
		label.textColor = Asset.PocketColors.pocketBlack.color
		label.numberOfLines = 0
		label.textAlignment = .center
		label.text = "Ждите в ближайших обновлениях"
		return label
	}()
	
    
    required init() {
        super.init()
		self.backgroundColor = Asset.PocketColors.backgroundPage.color
        super.addSubview(webView)
		super.addSubview(indicator)
        webView.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }

		indicator.snp.makeConstraints{
			$0.center.equalToSuperview()
			$0.width.height.equalTo(40)
		}
		
		self.addSubview(notReleasedLabel)
		self.notReleasedLabel.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.left.greaterThanOrEqualToSuperview().offset(20)
			make.right.lessThanOrEqualToSuperview().offset(-20)
		}
		self.notReleasedLabel.isHidden = true
		
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
