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
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
    
    private var _selectedIndex = 0
    private var buttons:[SwitchSelectorButton] = []
    public var switchDelegate:SwitchSelectorDelegate?
    public var animated = true
    
    public var selectedIndex:Int {
        get{
            return self._selectedIndex
        }
        set{
            self._selectedIndex = newValue < self.stack.arrangedSubviews.count ? newValue : 0
            UIView.animate(withDuration: self.animated ? 0.3 : 0) {
                self.updateView()
            }
        }
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
            self.selectedIndex = index
            self.switchDelegate?.didSelect(index)
        }, for: .touchUpInside)
        self.stack.addArrangedSubview(button)
        
    }
    public func updateView(){
        self.selectBackground.frame = self.stack.arrangedSubviews[self.selectedIndex].frame
        self.selectBackground.backgroundColor = self.buttons[selectedIndex].backgroundColor
        
        let selected = self.stack.arrangedSubviews[self.selectedIndex]
        for view in self.stack.arrangedSubviews{
            let button = view as? Button
            if view == selected{
                button?.setTitleColor(self.buttons[self.selectedIndex].selectedTitleColor, for: .normal)
            }else{
                button?.setTitleColor(self.buttons[self.selectedIndex].titleColor, for: .normal)
            }
            
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
}
public protocol SwitchSelectorDelegate {
    func didSelect(_ index:Int)
}
