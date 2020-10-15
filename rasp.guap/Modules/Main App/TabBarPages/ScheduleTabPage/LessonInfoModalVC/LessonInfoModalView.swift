//
//  LessonModalView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class LessonInfoModalView: View {
    private func sectionLabelGenerator() -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }
    func sectionTextGenerator() -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.numberOfLines = 0
        return label
    }
    
    lazy var nameSectionTitle: UILabel = {
        let label = sectionLabelGenerator()
        label.text = "Название предмета"
        return label
    }()
    lazy var timeSectionTitle: UILabel = {
        let label = sectionLabelGenerator()
        label.text = "Время проведения"
        return label
    }()
    lazy var prepSectionTitle: UILabel = {
        let label = sectionLabelGenerator()
        label.text = "Преподаватели"
        return label
    }()
    lazy var groupsSectionTitle: UILabel = {
        let label = sectionLabelGenerator()
        label.text = "Группы"
        return label
    }()
    lazy var tagsSectionTitle: UILabel = {
        let label = sectionLabelGenerator()
        label.text = "Дополнительные сведения"
        return label
    }()
    
    lazy var nameLabel: UILabel = sectionTextGenerator()
    lazy var timeLabel: UILabel = sectionTextGenerator()
    
    let prepStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    let tagStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        stack.spacing = 6
        return stack
    }()
    
    let groupList: ASCollectionView = {
        let collection = ASCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 80 ), collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = .clear
        return collection
    }()
    
    private let scroll: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
    }
    
    func addViews() {
        self.addSubview(nameSectionTitle)
        self.addSubview(nameLabel)
        self.addSubview(timeSectionTitle)
        self.addSubview(timeLabel)
        self.addSubview(prepSectionTitle)
        self.addSubview(prepStack)
        self.addSubview(groupsSectionTitle)
        self.addSubview(groupList)
        self.addSubview(tagsSectionTitle)
        self.addSubview(tagStack)
        
    }
    func setupConstraints() {
        //making width Constraints
        for view in self.subviews {
            view.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.right.lessThanOrEqualToSuperview()
            }
        }
        
        let spacing = 8
        nameSectionTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameSectionTitle.snp.bottom).offset(spacing)
        }
        timeSectionTitle.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(spacing)
        }
        timeLabel.snp.makeConstraints { (make) in
             make.top.equalTo(timeSectionTitle.snp.bottom).offset(spacing)
        }
        prepSectionTitle.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(spacing)
        }
        prepStack.snp.makeConstraints { (make) in
            make.top.equalTo(prepSectionTitle.snp.bottom).offset(spacing)
        }
        groupsSectionTitle.snp.makeConstraints { (make) in
            make.top.equalTo(prepStack.snp.bottom).offset(spacing)
        }
        groupList.snp.makeConstraints { (make) in
            make.top.equalTo(groupsSectionTitle.snp.bottom).offset(spacing)
            make.height.greaterThanOrEqualTo(22)
        }
        tagsSectionTitle.snp.makeConstraints { (make) in
            make.top.equalTo(groupList.snp.bottom).offset(spacing)
        }
        tagStack.snp.makeConstraints { (make) in
            make.top.equalTo(tagsSectionTitle.snp.bottom).offset(spacing)
            make.bottom.equalToSuperview()
        }
    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
