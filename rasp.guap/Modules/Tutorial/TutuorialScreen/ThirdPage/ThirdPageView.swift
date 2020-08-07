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
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        self.addSubview(imageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            let imageHeight:CGFloat = imageView.image?.size.height ?? 1
            let imageWidth:CGFloat = imageView.image?.size.width ?? 0
            make.width.equalTo(imageView.snp.height).multipliedBy(imageWidth/imageHeight)
            make.height.lessThanOrEqualTo(imageHeight)
            make.size.lessThanOrEqualToSuperview()
            make.width.height.lessThanOrEqualToSuperview().multipliedBy(0.8).priority(.high)
        }
    }
    
    private func setupText(){
        self.imageView.image = Asset.AppImages.TutorialPreview.deadline.image
        self.title.text = "Дедлайны"
        self.text.text = "Контролируй учебный процесс, ставь \nзадачи и выполняй их в срок"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
