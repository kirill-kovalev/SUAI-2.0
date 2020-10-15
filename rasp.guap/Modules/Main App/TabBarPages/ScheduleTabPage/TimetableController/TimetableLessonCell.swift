//
//  TimetableLessonCell.swift
//  rasp.guap
//
//  Created by Кирилл on 10.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

extension PocketDayView {
//	let pocketLessonView: PocketDayView = {
//		if AppSettings.isOldTimetableEnabled {return } else {return PocketDayView.fromNib(named: "NewPocketDayView")}
//	}()
	private var pocketLessonView: Self {self }
		
//	convenience init(lesson: SALesson? = nil ) {
//		super.init(frame: .zero)
//
//
//		if lesson != nil {
//			setLesson(lesson: lesson!)
//		}
//	}
	static func make(lesson: SALesson? = nil) -> PocketDayView {
		let cell = AppSettings.isOldTimetableEnabled ? PocketDayView.fromNib() : PocketDayView.fromNib(named: "NewPocketDayView")
		if let lesson = lesson { cell.setLesson(lesson: lesson) }
		return cell
	}
	
	private func wordCase(_ n: Int) -> String {
		let words = ["группа", "группы", "групп"]
		guard words.count >= 3 else { return ""}
		var n = n
		if n >= 5 && n <= 20 {
			return words[2]
		}
		n = n % 10
		if n == 1 {
			return  words[0]
		}
		if n >= 2 && n <= 4 {
			return  words[1]
		}
		return  words[2]
	}
	
	private func oldSetLesson(lesson: SALesson) {
//		self.lesson = lesson
		
		pocketLessonView.prep.text = lesson.prepods.isEmpty ? "Преподаватель не указан" : lesson.prepods[0].Name
		pocketLessonView.lessonNum.text = "\(lesson.lessonNum)"
		pocketLessonView.title.text = lesson.name
		
		addTag(text: lesson.type.rawValue)
		addTag(text: lesson.groups.count > 1 ? "\(lesson.groups.count) \(wordCase(lesson.groups.count))" : lesson.groups[0].Name)
		
		for tag in lesson.tags {
			addTag(text: tag)
		}
		pocketLessonView.startTime.text = lesson.start == "00:00" ? "НЕТ" : lesson.start
		pocketLessonView.endTime.text = lesson.end  == "00:00" ? "НЕТ" : lesson.end
		
		switch lesson.type {
			case .courseProject:
				pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketGreen.color

			case .lab:
				pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketAqua.color

			case .lecture:
				pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketPurple.color
			
			case .practice:
				pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketOrange.color
		}
	}
	
	private func newSetLesson(lesson: SALesson) {
//		self.lesson = lesson
		
		pocketLessonView.prep.text = lesson.prepods.isEmpty ? "Преподаватель не указан" : lesson.prepods[0].Name
		pocketLessonView.lessonNum.text = "\(lesson.lessonNum)"
		pocketLessonView.title.text = lesson.name
		
		addTag(text: lesson.groups.count > 1 ? "\(lesson.groups.count) \(wordCase(lesson.groups.count))" : lesson.groups[0].Name)
		
		for tag in lesson.tags {
			addTag(text: tag)
		}
		pocketLessonView.startTime.text = lesson.start == "00:00" ? "НЕТ" : lesson.start
		pocketLessonView.endTime.text = lesson.end  == "00:00" ? "НЕТ" : lesson.end
		
		switch lesson.type {
			case .courseProject:
				pocketLessonView.lessonType?.textColor = Asset.PocketColors.pocketGreen.color
				pocketLessonView.lessonType?.text = "Курсовой проект"
			
			case .lab:
				pocketLessonView.lessonType?.textColor = Asset.PocketColors.pocketAqua.color
				pocketLessonView.lessonType?.text = "Лабораторная"
			
			case .lecture:
				pocketLessonView.lessonType?.textColor = Asset.PocketColors.pocketPurple.color
				pocketLessonView.lessonType?.text = "Лекция"
			
			case .practice:
				pocketLessonView.lessonType?.textColor = Asset.PocketColors.pocketOrange.color
				pocketLessonView.lessonType?.text = "Практика"
		}
		
	}
	
	func setLesson(lesson: SALesson) {
		if AppSettings.isOldTimetableEnabled {
			oldSetLesson(lesson: lesson)
		} else {
			newSetLesson(lesson: lesson)
		}
	}
	private func addTag(text: String) {
		let tag = PocketTagButton()
		tag.setTitle(text, for: .normal)
		tag.isEnabled = false
		pocketLessonView.tagStack.addArrangedSubview(tag)
	}

}
