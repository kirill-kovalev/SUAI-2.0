//
//  ThirdPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ThirdPageView : TutorialPageView{
    
    // MARK: - Views
    
    let deadlines: [PocketDivView] = {
        var deadlines = [ PocketDeadlineView(), PocketDeadlineView(), PocketDeadlineView(), PocketDeadlineView(), PocketDeadlineView()]
        return deadlines.map { deadline in
            PocketDivView(content: deadline)
        }
    }()
    
    // MARK: - View setup
    
    required init() {
        super.init()
        setupText()
        addViews()
        setupConstraints()
    }
    
    override func addViews() {
        super.addViews()
        
        for deadline in deadlines {
            self.addSubview(deadline)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        for deadline in deadlines {
            deadline.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.width.equalToSuperview().inset(12)
            }
        }
    }
    
    private func setupText(){
        
        self.title.text = "Дедлайны"
        self.text.text = "Контролируй учебный процесс, ставь \nзадачи и выполняй их в срок"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
