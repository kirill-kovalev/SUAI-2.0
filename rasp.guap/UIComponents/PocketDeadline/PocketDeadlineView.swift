//
//  PocketDeadlineView.swift
//  rasp.guap
//
//  Created by Кирилл on 07.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


// temp class
// will be moved to model
enum DedadlineState{
    case nearest
    case open
    case closed
}

class PocketDeadlineView: View {
    
    public func setLessonText(lesson name:String){
        
    }
    public func setDescriptionText(description text:String){
        
    }
    public func setState(state:DedadlineState){
        switch state {
        case .nearest:
            imageView.image = prepareIcon(Asset.AppImages.DeadlineStateImages.recent.image)
            imageView.backgroundColor = Asset.PocketColors.pocketDeadlineRed.color
            imageView.tintColor = Asset.PocketColors.pocketRedButtonText.color
        break;
        case .open:
            imageView.image = prepareIcon(Asset.AppImages.DeadlineStateImages.recent.image)
            imageView.backgroundColor = Asset.PocketColors.pocketBlue.color
            imageView.tintColor = Asset.PocketColors.buttonOutlineBorder.color
        break;
            case .closed:
            imageView.image = prepareIcon(Asset.AppImages.DeadlineStateImages.recent.image)
            imageView.backgroundColor = Asset.PocketColors.pocketDeadlineGreen.color
            imageView.tintColor = Asset.PocketColors.pocketGreenButtonText.color
        break;
        }
    }
    
    // MARK: - views
    
    let authorLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketDarkBlue.color
        label.text = "ГУАП | SUAI"
        return label
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 15)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.numberOfLines = 2
        label.text = "Приходи на день абитуриента и выбирай свое будущее!"
        return label
    }()
    
    let imageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .center
        
        return imageView
    }()
    
    let articleIcon:UIImageView = {
        let icon = UIImageView(image: Asset.AppImages.DeadlineStateImages.article.image )
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Asset.PocketColors.pocketDarkBlue.color
        return icon
    }()
    let calendarIcon:UIImageView = {
        let icon = UIImageView(image: Asset.AppImages.DeadlineStateImages.calendar.image )
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Asset.PocketColors.pocketDarkBlue.color
        return icon
    }()
    

    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
        
        self.setState(state: .nearest)
        
        self.setState(state: .closed)
    }
    
    private func addViews(){
        
        self.addSubview(authorLabel)
        self.addSubview(titleLabel)
        self.addSubview(imageView)

    }
    
    private func setupConstraints(){
        self.imageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.height.width.equalTo(44)
        }
        
       
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareIcon(_ image:UIImage) -> UIImage {
        let newSize = CGSize(width: 28, height: 28)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage.withRenderingMode(.alwaysTemplate)
    }
    
    
}
