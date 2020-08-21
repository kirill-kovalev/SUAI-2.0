//
//  PocketDeadlineView.swift
//  rasp.guap
//
//  Created by Кирилл on 07.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


// temp class
// will be moved to model
enum DedadlineState{
    case nearest
    case open
    case closed
}

class PocketDeadlineView: View {
    
    public func setLessonText(lesson name:String?){
        self.lessonLabel.text = name
        if name == "" || name == nil {
            self.calendarIcon.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
        }else{
            self.calendarIcon.snp.updateConstraints { (make) in
                make.width.equalTo(20)
            }
        }
        
    }
    public func setDescriptionText(description text:String?){
        if text == "" || text == nil || text == " " {
            self.articleIcon.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
        }else{
            self.articleIcon.snp.updateConstraints { (make) in
                make.width.equalTo(20)
            }
        }
    }
    public func setTitleText(description text:String?){
        self.titleLabel.text = text
    }
    public func setState(state:DedadlineState){
        switch state {
        case .nearest:
            imageView.image = prepareIcon(Asset.AppImages.DeadlineStateImages.recent.image)
            imageView.backgroundColor = Asset.PocketColors.pocketDeadlineRed.color
            imageView.tintColor = Asset.PocketColors.pocketRedButtonText.color
            
            checkbox.isChecked = false
            break;
        case .open:
            imageView.image = prepareIcon(Asset.AppImages.DeadlineStateImages.recent.image)
            imageView.backgroundColor = Asset.PocketColors.pocketBlue.color
            imageView.tintColor = Asset.PocketColors.buttonOutlineBorder.color
            
            checkbox.isChecked = false
            break;
        case .closed:
            imageView.image = prepareIcon(Asset.AppImages.DeadlineStateImages.done.image)
            imageView.backgroundColor = Asset.PocketColors.pocketDeadlineGreen.color
            imageView.tintColor = Asset.PocketColors.pocketGreenButtonText.color
            
            checkbox.isChecked = true
            break;
        }
    }
    
    // MARK: - views
    
    let titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.numberOfLines = 2
        label.text = "Название дедлайна \nв две строки"
        return label
    }()
    
    let lessonLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 13)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "Какой-то предмет"
        label.numberOfLines = 1
        return label
    }()
    
    let imageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .center
        
        return imageView
    }()
    
    let articleIcon:UIImageView = {
        let icon = UIImageView(image: Asset.AppImages.DeadlineStateImages.article.image )
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Asset.PocketColors.pocketDarkBlue.color
        return icon
    }()
    let calendarIcon:UIImageView = {
        let icon = UIImageView(image: Asset.AppImages.DeadlineStateImages.calendar.image )
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Asset.PocketColors.pocketDarkBlue.color
        return icon
    }()
    let checkbox:CheckBox = {
        let checkbox = CheckBox(frame: .zero)
        checkbox.checkmarkColor = Asset.PocketColors.pocketDarkBlue.color
        checkbox.uncheckedBorderColor = Asset.PocketColors.pocketLightGray.color
        checkbox.checkedBorderColor =  Asset.PocketColors.pocketDarkBlue.color
        return checkbox
    }()
    
    
    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
        setState(state: .nearest)
        
    }
    
    private func addViews(){
        
        self.addSubview(lessonLabel)
        self.addSubview(titleLabel)
        self.addSubview(imageView)
        
        self.addSubview(articleIcon)
        self.addSubview(calendarIcon)
        
        self.addSubview(self.checkbox)
    }
    
    private func setupConstraints(){
        self.imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview()
            make.left.equalTo(imageView.snp.right).offset(12)
            make.right.lessThanOrEqualTo(self.articleIcon.snp.left)
            make.centerY.lessThanOrEqualToSuperview()
        }
        self.lessonLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(12)
            make.right.equalTo(titleLabel)
            make.centerY.greaterThanOrEqualToSuperview()
            
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
        }
        self.articleIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
            make.right.equalTo(self.calendarIcon.snp.left).inset(-6)
        }
        self.calendarIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
            make.right.equalTo(self.checkbox.snp.left).inset(-6)
        }
        self.checkbox.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
            make.right.equalToSuperview()
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareIcon(_ image:UIImage) -> UIImage {
        let newSize = CGSize(width: 28, height: 28)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage.withRenderingMode(.alwaysTemplate)
    }
    
    
}
