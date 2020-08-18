//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ScheduleTabView:TabBarPageView{
    let pocketDiv = PocketDivView()
    let loadingIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.color = Asset.PocketColors.pocketGray.color
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    let selectButton:Button = {
        let btn = Button(frame: .zero)
        btn.setImage(Asset.SystemIcons.scheduleFilter.image.withRenderingMode(.alwaysTemplate), for: .normal)
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
    let todayButton : Button = {
        let btn = Button(frame: .zero)
        btn.setTitle("Сегодня", for: .normal)
        btn.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
        btn.titleLabel?.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        return btn
    }()
    let noLessonView:UIView={
        let view = UIView(frame: .zero)
        //view.isHidden = true
        return view
    }()
    
    let noLessonTitle:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 20)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
    private let noLessonImage:UIImageView = {
        let image = Asset.AppImages.TabBarImages.schedule.image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image )
        imageView.tintColor = Asset.PocketColors.accent.color
        
        return imageView
    }()
    private let noLessonSubtitle:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "Можно спать спокойно!"
        return label
    }()
    
    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
        
    }
    
    private func addViews(){
        self.addSubview(pocketDiv)
        pocketDiv.addSubview(loadingIndicator)
        self.addHeaderButton(selectButton)
        self.addSubview(dayLabel)
        self.addSubview(todayButton)
        
        pocketDiv.addSubview(noLessonView)
        noLessonView.addSubview(noLessonImage)
        noLessonView.addSubview(noLessonTitle)
        noLessonView.addSubview(noLessonSubtitle)
    }
    private func setupConstraints(){
        dayLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview()
        }
        todayButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(dayLabel)
            make.right.equalToSuperview().inset(10)
        }
        pocketDiv.snp.makeConstraints { (make) in
            make.top.equalTo(dayLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        noLessonView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        noLessonImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(56).priority(.medium)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(noLessonTitle.snp.top).inset(-10).priority(.medium)
            make.top.greaterThanOrEqualToSuperview().offset(25).priority(.medium)
        }
        noLessonTitle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        noLessonSubtitle.snp.makeConstraints { (make) in
            make.top.equalTo(noLessonTitle.snp.bottom).offset(10).priority(.medium)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(25).priority(.medium)
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.centerY.equalTo(title)
        }
    }
    
    func showIndicator(show:Bool){
        self.loadingIndicator.snp.removeConstraints()
        if show {
            loadingIndicator.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview().offset(50)
                make.bottom.lessThanOrEqualToSuperview().inset(50)
            }
        }
        self.loadingIndicator.isHidden = !show
    }
    func showNoLesson(show:Bool){
        self.noLessonView.snp.removeConstraints()
        if show {
            noLessonView.snp.makeConstraints { (make) in
                make.top.bottom.left.right.equalToSuperview()
            }
        }else{
            noLessonView.snp.makeConstraints { (make) in
                make.height.equalTo(0).priority(.high)
            }
        }
        self.noLessonView.isHidden = !show
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
