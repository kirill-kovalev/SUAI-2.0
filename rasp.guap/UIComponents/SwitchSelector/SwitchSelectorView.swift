//
//  SwitchSelectorView.swift
//  rasp.guap
//
//  Created by Кирилл on 29.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

public class SwitchSelector: UIScrollView {
    private lazy var stack:UIStackView = {
        let s = UIStackView(frame: .zero)
        s.axis = .horizontal
        return s
    }()
    private let selectBackground :UIView = {
        let v = UIView(frame: .zero)
        v.layer.cornerRadius = 10
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stack)
        self.stack.addSubview(selectBackground)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        stack.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.top.left.right.bottom.equalTo(self.contentLayoutGuide)
        }
    }
	
	
	private var justCleared:Bool = true
    private var _selectedIndex = 0
    private var buttons:[SwitchSelectorButton] = []
    public var switchDelegate:SwitchSelectorDelegate?
    public var animated = true
    public var feedback = true
    
	public var count:Int { self.buttons.count}
    public var selectedIndex:Int {
        get{
            return self._selectedIndex
        }
        set{
			self.stack.layoutIfNeeded()
            self._selectedIndex = newValue // < self.stack.arrangedSubviews.count ? newValue : -1
            UIView.animate(withDuration: (self.animated && !justCleared) ? 0.3 : 0) {
                self.updateView()
            }
			justCleared = false
        }
    }
	public var selectedValue:Any? {
		if self.selectedIndex >= 0 && self.selectedIndex < self.buttons.count{
			return self.buttons[selectedIndex].value
		}
		return nil
	}
	
	
	public func clear(){
		for b in self.stack.arrangedSubviews{
			b.removeFromSuperview()
		}
		self.buttons = []
		self.selectBackground.frame = .zero
		self.justCleared = true
	}
	
    public func add(_ element:SwitchSelectorButton){
        let index = buttons.count
        buttons.append(element)
        
        let button = Button(frame: .zero)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        button.titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().inset(7)
        })
        button.setTitle(element.title, for: .normal)
        button.addTarget(action: { (sender) in
			if self.feedback { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
			if self.selectedIndex != index {
				self.selectedIndex = index
			    self.switchDelegate?.didSelect(index)
			}
           
        }, for: .touchUpInside)
        self.stack.addArrangedSubview(button)
    }
	
	
    public func updateView(){
        if self.selectedIndex >= 0 && self.selectedIndex < self.stack.arrangedSubviews.count && self.selectedIndex < self.buttons.count{
            
			self.selectBackground.frame = self.stack.arrangedSubviews[self.selectedIndex].frame
            self.selectBackground.backgroundColor = self.buttons[selectedIndex].backgroundColor
            
            let selected = self.stack.arrangedSubviews[self.selectedIndex]
			for (i,view) in self.stack.arrangedSubviews.enumerated(){
                let button = view as? Button
                if view == selected{
                    button?.setTitleColor(self.buttons[i].selectedTitleColor, for: .normal)
                }else{
                    button?.setTitleColor(self.buttons[i].titleColor, for: .normal)
                }
            }
			if selected.frame.origin.x < self.contentOffset.x { self.contentOffset.x = selected.frame.origin.x}
			let rightX = selected.frame.origin.x + selected.frame.width
			let overflow = self.frame.width + self.contentOffset.x - rightX
			if (rightX - self.contentOffset.x) > (self.frame.width) { self.contentOffset.x -= overflow}
		} else{
			
			for (i,view) in self.stack.arrangedSubviews.enumerated(){
				(view as? Button)?.setTitleColor(self.buttons[i].titleColor, for: .normal)
				
			}
			self.selectBackground.frame.origin.x += self.selectBackground.frame.size.width/2
			self.selectBackground.frame.size.width = 0
			self.selectBackground.backgroundColor = .clear
		}

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


public struct SwitchSelectorButton{
    public let title:String
    
    public let titleColor:UIColor
    public let selectedTitleColor:UIColor
    
    public let backgroundColor:UIColor
	public let value:Any?
	init(title:String,titleColor:UIColor,selectedTitleColor:UIColor,backgroundColor:UIColor,value:Any? = nil) {
		self.title = title
		self.titleColor = titleColor
		self.selectedTitleColor = selectedTitleColor
		self.backgroundColor = backgroundColor
		self.value = value
	}
}
public protocol SwitchSelectorDelegate {
    func didSelect(_ index:Int)
}
