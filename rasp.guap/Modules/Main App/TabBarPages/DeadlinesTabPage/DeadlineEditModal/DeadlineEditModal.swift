//FUCK MVC
//
//  DeadlineEditModal.swift
//  rasp.guap
//
//  Created by Кирилл on 24.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DeadlineEditModalView: View {
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
        btn.setTitleColor(Asset.PocketColors.pocketGray.color, for: .disabled)
        btn.layer.borderColor = color.cgColor

        return btn
    }
    private func textFieldGenerator(_ title:String = "")->UITextField{
        let field = UITextField(frame: .zero)
        field.placeholder = title
        field.font = FontFamily.SFProDisplay.regular.font(size: 14)
        
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        field.rightViewMode = .always
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        field.leftViewMode = .always
        
        
        field.layer.cornerRadius = 10
        field.backgroundColor = Asset.PocketColors.pocketLightGray.color
        field.textRect(forBounds: field.bounds.insetBy(dx: 5, dy: 5))
        
        
        field.doneAccessory = true
        return field
    }
    
    
    
    lazy var nameSectionTitle:UILabel = sectionLabelGenerator("Название дедлайна")
    lazy var commentSectionTitle:UILabel = sectionLabelGenerator("Описание дедлайна")
    lazy var dateSectionTitle:UILabel = sectionLabelGenerator("Дата дедлайна")
    lazy var lessonSectionTitle:UILabel = sectionLabelGenerator("Предмет")
    
    lazy var nameLabel:UITextField = textFieldGenerator("Выполнить лабораторную работу №1")
    lazy var commentLabel:UITextView = {
        let field = UITextViewFixed(frame: .zero)
        field.layer.cornerRadius = 10
        field.backgroundColor = Asset.PocketColors.pocketLightGray.color
        field.font = FontFamily.SFProDisplay.regular.font(size: 14)
		field.placeholder = "Написать программу, сделать по ней отчет и защитить"
		field.contentOffset = .init(x: 12, y: 12)
        field.doneAccessory = true
        return field
    }()
    
    lazy var formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU")
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    lazy var datePicker:UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.locale = Locale(identifier: "Ru")
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    lazy var dateLabel:UITextField = {
    
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dateCancelSeleceted))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateSeleceted))
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton,spacer,doneButton], animated: true)

        let dateLabel = textFieldGenerator("2012-01-01")
        
        dateLabel.text = formatter.string(from: Date())
        dateLabel.inputAccessoryView = toolbar
        dateLabel.inputView = self.datePicker
        return dateLabel
    }()
    
    @objc private func dateSeleceted(){
        guard let inputView = dateLabel.inputView as? UIDatePicker else {
            dateLabel.resignFirstResponder()
            return
        }
        self.dateLabel.text = formatter.string(from: inputView.date)
        dateLabel.resignFirstResponder()
    }
    @objc private func dateCancelSeleceted(){
        dateLabel.resignFirstResponder()
    }
    
    
    
    lazy var lessonPicker = UIPickerView()
    
    lazy var lessonLabel:UITextField = {
        let lessonLabel = textFieldGenerator("Не выбрано")
        lessonLabel.inputView = lessonPicker
        
        let image = UIImageView(image: Asset.SystemIcons.searchDropdown.image.withRenderingMode(.alwaysTemplate))
        image.tintColor = Asset.PocketColors.pocketGray.color
        lessonLabel.rightView = image
        lessonLabel.rightViewMode = .unlessEditing
        return lessonLabel
    }()
    
    
    
    lazy var closeButton:Button = buttonGenerator("Создать дедлайн")
    
    
    
    
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
        
    }
    func setupConstraints(){
        nameSectionTitle.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(nameSectionTitle.snp.bottom).offset(8)
        }
        commentSectionTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        commentLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalTo(commentSectionTitle.snp.bottom).offset(8)
        }
        dateSectionTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(commentLabel.snp.bottom).offset(8)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(dateSectionTitle.snp.bottom).offset(8)
        }
        lessonSectionTitle.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
        }
        lessonLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(lessonSectionTitle.snp.bottom).offset(8)
        }
        closeButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(lessonLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
            
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}




@IBDesignable class UITextViewFixed: UITextView {
	private class Delegate:NSObject,UITextViewDelegate{
		func textViewDidChange(_ textView: UITextView) {
			(textView as? UITextViewFixed)?.placehlderLabel.isHidden = (textView.text != "")
		}
	}
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame:frame,textContainer:textContainer)
		
	}
	public var placeholder:String{
		get{self.placehlderLabel.text ?? ""}
		set{self.placehlderLabel.text = newValue}
	}
	lazy var placehlderLabel:UILabel = {
		let label = UILabel(frame: .zero)
		label.numberOfLines = 0
		label.font = self.font
		label.textColor = UIColor(displayP3Red: 0.92, green: 0.92, blue: 0.96, alpha: 0.3) //R:0,92 G:0,92 B:0,96 A:0,3
		label.contentMode = .topLeft
		label.textAlignment = .left
		label.text = "fgdfgdf"
		return label
	}()
	private var editController = Delegate()
	required init?(coder: NSCoder) {
		super.init(coder:coder)
		self.addSubview(placehlderLabel)
	}
	override func layoutSubviews() {
        super.layoutSubviews()
		print("layout")
        setup()
		self.delegate = self.editController
		self.addSubview(placehlderLabel)
		placehlderLabel.frame = self.bounds.inset(by: textContainerInset)
		placehlderLabel.sizeToFit()
		placehlderLabel.isHidden = (self.text != "")
    }
    func setup() {
        textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 12, right: 12)
        textContainer.lineFragmentPadding = 0
    }
}
