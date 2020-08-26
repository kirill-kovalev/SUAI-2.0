//
//  DeadlineListCell.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class DeadlineListCell: PocketDeadlineView{
    public func onSelect( action: @escaping (DeadlineListCell)->Void){
        self.onSelectFunc = action
    }
    public func onCheck(action: @escaping (DeadlineListCell)->Void){
        self.onCheckFunc = action
    }
    
    private var onCheckFunc:((DeadlineListCell)->Void)?
    private var onSelectFunc:((DeadlineListCell)->Void)?
    
    @objc private func selectHandler(_ sender: UITapGestureRecognizer){
        if sender.location(in: self).x < self.checkbox.frame.minX {
            self.onSelectFunc?(self)
        }else{
            self.checkbox.isChecked.toggle()
            self.onCheckFunc?(self)
        }
    }
    @objc private func checkHandler(){
        self.onCheckFunc?(self)
    }
    
        
    required init() {
        super.init()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectHandler(_:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}