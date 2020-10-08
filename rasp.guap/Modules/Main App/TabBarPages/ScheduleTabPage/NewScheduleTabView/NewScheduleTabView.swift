//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class NewScheduleTabView:TabBarPageView{
    

    let selectButton:Button = {
        let btn = Button(frame: .zero)
		btn.setImage(Asset.SystemIcons.searchLense.image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Asset.PocketColors.pocketGray.color
        return btn
    }()
    
    let dayLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "Понедельник"
        return label
    }()
    
	let table:UITableView = {
		let table = UITableView(frame: .zero)
		table.allowsSelection = false
		table.estimatedRowHeight = 130
		table.separatorStyle = .none
		table.backgroundColor = .clear
		return table
	}()
	let activityIndicator = PocketActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
	
	
	
    required init() {
        super.init()
        addViews()
        setupConstraints()
        
    }
    
    private func addViews(){
        self.addHeaderButton(selectButton)
		self.addSubview(activityIndicator)
		self.addSubview(table)
    }
    private func setupConstraints(){
		activityIndicator.snp.makeConstraints { (make) in
			make.height.width.equalTo(40)
			make.center.equalTo(table)
		}
		selectButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.centerY.equalTo(title)
        }
		table.snp.makeConstraints { (make) in
			make.top.left.right.equalToSuperview()
			make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
			make.height.equalTo(self).priority(.low)
		}
    }
    
  
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
