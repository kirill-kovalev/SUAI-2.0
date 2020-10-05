//
//  NewScheduleTabTableCell.swift
//  rasp.guap
//
//  Created by Кирилл on 05.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class NewScheduleTabTableCell:UITableViewCell{
	let controller = TimetableViewController(timetable: [])
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		initSetup()
	}
	let dayLabel:UILabel = {
		let label = UILabel(frame: .zero)
		label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
		label.textColor = Asset.PocketColors.pocketGray.color
		label.text = "Понедельник"
		return label
	}()
	let placeholder = PocketDivView(content: NewScheduleDayPlaceholder())
	lazy var container = PocketDivView(content: controller.view)
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initSetup()
	}
	private func initSetup(){
		Logger.print(from: #function, "\(Self.self) init setup")
		
		self.contentView.addSubview(placeholder)
		self.contentView.addSubview(container)
		self.contentView.addSubview(dayLabel)
		self.backgroundColor = .clear
		self.contentView.backgroundColor = .clear
		
	
		dayLabel.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(8)
			make.left.equalToSuperview().offset(8)
			make.right.equalToSuperview().inset(8)
		}
		container.snp.makeConstraints { make in
			make.top.equalTo(dayLabel.snp.bottom).offset(8)
			make.left.right.equalTo(dayLabel)
			make.bottom.lessThanOrEqualToSuperview().inset(8)
		}
		placeholder.snp.makeConstraints { (make) in
			make.left.right.top.equalTo(container)
			make.bottom.equalToSuperview().inset(8)
		}
	}
	typealias CellDelegate = UIViewController & UserChangeDelegate
	public func setupCell(_ cellDelegate:CellDelegate,timetable:[SALesson]){
		placeholder.isHidden = !timetable.isEmpty
		container.isHidden = !placeholder.isHidden
		
		cellDelegate.addChild(self.controller)
		controller.didMove(toParent: cellDelegate)
		self.controller.setTimetable(timetable: timetable)
		self.controller.cellDelegate = cellDelegate
	}
}
