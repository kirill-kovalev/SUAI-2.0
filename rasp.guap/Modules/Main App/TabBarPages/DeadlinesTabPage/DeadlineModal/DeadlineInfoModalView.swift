//
//  DeadlineInfoModalView.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DeadlineInfoModalView: UIStackView {
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
    private func buttonGenerator(_ text:String,image:UIImage? = nil) -> PocketLongActionButton {
		let btn = PocketLongActionButton(frame: .zero)
		btn.setTitle(text, for: .normal)
		btn.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
		btn.setTitleColor(Asset.PocketColors.pocketDarkBlue.color, for: .normal)
		btn.setTitleColor(Asset.PocketColors.pocketGray.color, for: .disabled)
		return btn
    }
    
    
    
    lazy var closeButton:PocketLongActionButton = buttonGenerator("Открыть дедлайн")
    lazy var editButton:Button = buttonGenerator(" Редактировать",image: Asset.AppImages.DeadlineModal.edit.image)
    lazy var deleteButton:PocketLongActionButton = {
        
        let color = Asset.PocketColors.pocketError.color
        
        let btn = buttonGenerator(" Удалить",image: Asset.AppImages.DeadlineModal.delete.image)
        btn.imageView?.tintColor = color
        btn.setTitleColor(color, for: .normal)
        btn.layer.borderColor = color.cgColor
        return btn
    }()
	let buttonContainer = UIView(frame: .zero)
    
    
    required init(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    required init() {
		super.init(frame:.zero)
		self.axis = .vertical
		self.spacing = 8
        addViews()
        setupConstraints()
    }
	
	func addBlock(title:String,text:String){
		self.addArrangedSubview(sectionLabelGenerator(title))
		self.addArrangedSubview(sectionTextGenerator(text))
	}
	
    func addViews(){
        buttonContainer.addSubview(closeButton)
        buttonContainer.addSubview(editButton)
        buttonContainer.addSubview(deleteButton)
        
    }
    func setupConstraints(){
        
        closeButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        editButton.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalTo(buttonContainer.snp.centerX)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2).inset(5)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        //
    }
    
}
