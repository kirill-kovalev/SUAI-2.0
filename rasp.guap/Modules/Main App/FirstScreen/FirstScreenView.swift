//
//  FirstScreenView.swift
//  AirrouteApp
//
//  Created by Кирилл on 30.07.2020.
//  Copyright © 2020 kirill-kovalev. All rights reserved.
//

import UIKit

class FirstScreenView: MainView {
	
	let label: UILabel = {
		let label = UILabel(frame: .zero)
		label.text = "Hello World!"
		label.textColor = .textFirstLevel
		return label
	}()
    let btn :Button = {
        let btn = Button(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Show", for: .normal)
        btn.setTitleColor(.textFirstLevel, for: .normal)
        return btn;
    }()
    let btn2 :Button = {
        let btn = Button(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Go", for: .normal)
        btn.setTitleColor(.textFirstLevel, for: .normal)
        return btn;
    }()
    let btn3 :Button = {
        let btn = Button(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Alert", for: .normal)
        btn.setTitleColor(.textFirstLevel, for: .normal)
        return btn;
    }()
    let textInput:UITextField =  {
        let field = UITextField(frame: .zero)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
	
	
	required init() {
		super.init()
        self.backgroundColor = .backgroundFirstLevel
		
		addViews()
		setupConstraints()
		
	}

	private func addViews(){
		self.addSubview(label)
        self.addSubview(btn)
        self.addSubview(btn2)
        self.addSubview(btn3)
	}
	
	private func setupConstraints(){
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
			NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
		])
		
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: btn, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: btn2, attribute: .top, relatedBy: .equal, toItem: btn, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: btn2, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: btn3, attribute: .top, relatedBy: .equal, toItem: btn2, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: btn3, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        
        
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
