//
//  DeadlineInfoModalView.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DeadlineInfoModalView: View {
    private func sectionLabelGenerator(_ text:String) -> UILabel{
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.text = text
        return label
    }
    private func sectionTextGenerator(_ text:String = "") -> UILabel{
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.numberOfLines = 0
        label.text = text
        return label
    }
    private func buttonGenerator(_ text:String,image:UIImage? = nil) -> Button {
        let color = Asset.PocketColors.pocketDarkBlue.color
        let btn = Button(frame: .zero)
        btn.setTitle(text, for: .normal)
        btn.titleLabel?.font = FontFamily.SFProDisplay.bold.font(size: 12)
        btn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1
        
        btn.imageView?.tintColor = color
        btn.setTitleColor(color, for: .normal)
        btn.layer.borderColor = color.cgColor
        
        btn.titleLabel?.snp.makeConstraints({ (make) in
            
            make.height.equalTo(40)
        })
        return btn
    }
    
    
    
    lazy var nameSectionTitle:UILabel = sectionLabelGenerator("Название дедлайна")
    lazy var commentSectionTitle:UILabel = sectionLabelGenerator("Описание дедлайна")
    lazy var dateSectionTitle:UILabel = sectionLabelGenerator("Дата дедлайна")
    lazy var lessonSectionTitle:UILabel = sectionLabelGenerator("Предмет")
    
    lazy var nameLabel:UILabel = sectionTextGenerator()
    lazy var commentLabel:UILabel = sectionTextGenerator()
    lazy var dateLabel:UILabel = sectionTextGenerator()
    lazy var lessonLabel:UILabel = sectionTextGenerator()
    
    
    
    lazy var closeButton:Button = buttonGenerator("Открыть дедлайн")
    lazy var editButton:Button = buttonGenerator(" Редактировать",image: Asset.AppImages.DeadlineModal.edit.image)
    lazy var deleteButton:Button = {
        
        let color = Asset.PocketColors.pocketError.color
        
        let btn = buttonGenerator(" Удалить",image: Asset.AppImages.DeadlineModal.delete.image)
        btn.imageView?.tintColor = color
        btn.setTitleColor(color, for: .normal)
        btn.layer.borderColor = color.cgColor
        return btn
    }()
    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
    }
    
    func addViews(){
        self.addSubview(nameSectionTitle)
        self.addSubview(commentSectionTitle)
        self.addSubview(dateSectionTitle)
        self.addSubview(nameLabel)
        self.addSubview(commentLabel)
        self.addSubview(dateLabel)
        self.addSubview(lessonSectionTitle)
        self.addSubview(lessonLabel)
        
        self.addSubview(closeButton)
        self.addSubview(editButton)
        self.addSubview(deleteButton)
        
    }
    func setupConstraints(){
        nameSectionTitle.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameSectionTitle.snp.bottom).offset(8)
        }
        commentSectionTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        commentLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(commentSectionTitle.snp.bottom).offset(8)
        }
        dateSectionTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(commentLabel.snp.bottom).offset(8)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(dateSectionTitle.snp.bottom).offset(8)
        }
        lessonSectionTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
        }
        lessonLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(lessonSectionTitle.snp.bottom).offset(8)
        }
        closeButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(lessonLabel.snp.bottom).offset(8)
        }
        editButton.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
            make.bottom.lessThanOrEqualToSuperview()
        }
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).inset(5)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        //
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

protocol DeadlinChangeDelegate {
    
}
