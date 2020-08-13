//
//  LessonModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class LessonInfoModalViewController : ModalViewController<LessonInfoModalView>{
    var lesson:Timetable.Lesson = Timetable.Lesson()
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        switch lesson.type {
        case .courseProject:
            
            self.content.backgroundColor = Asset.PocketColors.pocketPurple.color
            break;
        case .lab:
            self.content.backgroundColor = Asset.PocketColors.pocketGreen.color
            break
        case .lecture:
            self.content.backgroundColor = Asset.PocketColors.pocketAqua.color
            break
            
        case .practice:
            self.content.backgroundColor = Asset.PocketColors.pocketOrange.color
            break

        }
    }
}
