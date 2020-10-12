//
//  FourthPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FourthPageView: TutorialPageView {
    // MARK: - Views
    let tableContainer: PocketDivView = PocketDivView()
   
     // MARK: - View setup
    
    required init() {
        super.init()
        setupText()
        addViews()
        setupGesture()
        setupConstraints()
    }
    
    override func addViews() {
        super.addViews()
        self.addSubview(tableContainer)
    }
    private func setupGesture() {
        tableContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureHandler(_:))))
    }
    @objc private func gestureHandler(_ sender: UIPanGestureRecognizer) {
        let y = sender.translation(in: self).y * 0.3
        if sender.state == .changed {
            self.tableContainer.transform = CGAffineTransform(translationX: 0, y: y )
        } else if sender.state == .ended {
            UIView.animate(withDuration: 2, delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: y>0 ? y * 0.1 : -y * 0.1  ,
                       options: [.allowUserInteraction],
                       animations: {
                                self.tableContainer.transform = .identity
                            
                        }, completion: nil)
        }
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        tableContainer.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(12)
        }
    }
    
    private func setupText() {
        self.title.text = "Расписание"
        self.text.text = "Смотри расписание преподавателей и \nгрупп в реальном времени"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
