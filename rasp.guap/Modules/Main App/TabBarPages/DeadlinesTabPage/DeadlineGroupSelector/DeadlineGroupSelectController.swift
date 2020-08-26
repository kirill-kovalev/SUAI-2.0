//
//  DeadlineGroupSelectController.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
class DeadlineGroupSelectController: UIViewController {
    
    var stackView:UIStackView {
        return self.view as! UIStackView
    }
    var background : UIView = {
        let v = UIView(frame: .zero)
        v.layer.cornerRadius = 10
        return v
    }()
    
    private func buttonGenerator(_ title:String)->Button{
        let btn = Button(frame: .zero)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = FontFamily.SFProDisplay.bold.font(size: 14)
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 8
        btn.titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(12)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
        })
        return btn;
    }
    lazy var nearestButton:Button = buttonGenerator("Ближайшие")
    lazy var openButton:Button = buttonGenerator("Открытые")
    lazy var closedButton:Button = buttonGenerator("Закрытые")
    private lazy var buttons:[Button] = [nearestButton,openButton,closedButton]
    
    override func loadView() {
        self.view = UIStackView(frame: .zero)
        self.stackView.axis = .horizontal
        self.stackView.spacing = 6
        
        self.stackView.addSubview(self.background)
        self.stackView.addArrangedSubview(nearestButton)
        self.stackView.addArrangedSubview(openButton)
        self.stackView.addArrangedSubview(closedButton)
    }
    
    
    var delegate:DeadlineGroupSelectControllerDelegate?
    
    private(set) var current = SADeadlineGroup.nearest
    
    override func viewDidLoad() {
        nearestButton.addTarget(action: { (sender) in
            self.highlightButtonAnimated(btn: sender)
            self.current = .nearest
            self.delegate?.didSelect(group: self.current)
        }, for: .touchUpInside)
        
        openButton.addTarget(action: { (sender) in
            self.highlightButtonAnimated(btn: sender)
            self.current = .open
            self.delegate?.didSelect(group: self.current)
        }, for: .touchUpInside)
        
        closedButton.addTarget(action: { (sender) in
            self.highlightButtonAnimated(btn: sender)
            self.current = .closed
            self.delegate?.didSelect(group: self.current)
        }, for: .touchUpInside)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.highlightButton(btn: nearestButton)
    }
    
    private func highlightButton(btn:Button){
        self.background.frame = btn.frame
        for b in self.buttons{
            b.backgroundColor = .clear
            b.setTitleColor(Asset.PocketColors.pocketGray.color, for: .normal)
        }
        if btn == nearestButton{
            background.backgroundColor = Asset.PocketColors.pocketDeadlineRed.color
            btn.setTitleColor(Asset.PocketColors.pocketRedButtonText.color, for: .normal)
        }else{
            background.backgroundColor = Asset.PocketColors.pocketBlue.color
            btn.setTitleColor(Asset.PocketColors.buttonOutlineBorder.color, for: .normal)
        }
    }
    
    
    private func highlightButtonAnimated(btn:Button){
        UIView.animate(withDuration: 0.3) {
            self.highlightButton(btn: btn)
        }
    }
    
}




