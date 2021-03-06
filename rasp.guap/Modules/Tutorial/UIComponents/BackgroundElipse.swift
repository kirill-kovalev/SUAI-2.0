//
//  TutorialBackgroundElipse.swift
//  rasp.guap
//
//  Created by Кирилл on 05.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
extension TutorialScreenView{
    

    class BackgroundElipse: UIImageView {
        
        private var rootView:UIView = UIView(frame: .zero)
        
        
        init() {
            super.init(frame: .zero)
            self.image = UIImage(named: "TutorialEipse")?.withRenderingMode(.alwaysTemplate)
            self.contentMode = .scaleToFill
            rootView = self.superview ?? UIView(frame: UIScreen.main.bounds)
            setState(position: 0)
        }
        
        
        
        // all poossible Ellipse states
        func setState(position: Int){
            switch position  {
                case 0:
                    self.transform = CGAffineTransform(rotationAngle: -56.degreesToRadians )
                        .concatenating(CGAffineTransform(translationX: self.rootView.frame.width * 4/5, y: -self.rootView.frame.height * 3/5 ))
                    
                    self.tintColor = Asset.PocketColors.pocketLightGray.color
                    
                break;
                case 1:
                    self.transform = CGAffineTransform(rotationAngle: -42.degreesToRadians)
                        .concatenating(CGAffineTransform(translationX: 0, y: -self.rootView.frame.height * 1/3))
                    
                    self.tintColor = Asset.PocketColors.pocketLightGray.color
                    
                break;
                case 2:
                    self.transform = CGAffineTransform(rotationAngle: -106.degreesToRadians )
                        .concatenating(CGAffineTransform(translationX: -self.rootView.frame.width * 3/5, y: -self.rootView.frame.height * 1/3 ))
                        
                    self.tintColor = Asset.PocketColors.pocketError.color
                    
                break;
                case 3:
                    self.transform = CGAffineTransform(rotationAngle: -61.degreesToRadians )
                        .concatenating(CGAffineTransform(translationX: self.rootView.frame.width * 3/5, y: -self.rootView.frame.height/4))
                    self.tintColor = Asset.PocketColors.pocketLightGray.color
                    
                break;
                
                case 4:
                    self.transform = CGAffineTransform(rotationAngle: -70.degreesToRadians )
                        .concatenating(CGAffineTransform(translationX: self.rootView.frame.width * 3/4, y:  -self.rootView.frame.height * 3/4))
                    
                    self.tintColor = Asset.PocketColors.pocketLightGray.color
                    
                break;
                
                case 5:
                    self.transform = CGAffineTransform(rotationAngle: 14.degreesToRadians )
                        .concatenating(CGAffineTransform(translationX: self.rootView.frame.width * 1/2, y: self.rootView.frame.height * 1/5))
                        .concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                    
                    self.tintColor = Asset.PocketColors.pocketLightGray.color
                    
                break;
                
                default:
                    self.transform = CGAffineTransform(rotationAngle: 90 )
                        .concatenating(CGAffineTransform(translationX: 0, y: -self.rootView.frame.height/4))
                        .concatenating(CGAffineTransform(scaleX: 2, y: 2))
                break;
            }
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
    
}
