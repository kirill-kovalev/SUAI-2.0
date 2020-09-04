//
//  LessonModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class LessonInfoModalViewController : ModalViewController<LessonInfoModalView>{
    
    var lesson:SALesson
    var delegate:UserChangeDelegate?
	
	public var curUser:SAUsers.User? = nil
    
    init(lesson:SALesson?=nil) {
        self.lesson = lesson ?? SALesson()
        super.init()
    }
    
    required init() {
        self.lesson = SALesson()
        super.init()
    }
    required init?(coder: NSCoder) {
        self.lesson = SALesson()
        super.init(coder:coder)
    }

    
    
    override func viewDidLoad() {
		
        super.viewDidLoad()
		

        self.rootView.titleLabel.text = "Карточка предмета"
        self.content.nameLabel.text = lesson.name
        
		
        
        func hf(_ int:Int?)->String{ return String(format: "%.2i",  int ?? 0) }
        self.content.timeLabel.text = "\(hf(lesson.startTime.hour)):\(hf(lesson.startTime.minute)) - \(hf(lesson.endTime.hour)):\(hf(lesson.endTime.minute))"
        
        
        func stackElem(_ tagView:PocketTagButton) -> UIStackView{
            let hs = UIStackView(arrangedSubviews: [tagView,UIView(frame: .zero)] )
            hs.axis = .horizontal
            return hs
        }
		
        for prep in lesson.prepods {
            let tagView = PocketTagButton()
            tagView.setTitle(prep.Name, for: .normal)
            tagView.isActive = (prep != curUser)
            tagView.addTarget(action: { (sender) in
                self.setNewUser(user: prep)
            }, for: .touchUpInside)
            self.content.prepStack.addArrangedSubview(stackElem(tagView))
            
            backgroundUserLoad(user: prep)
        }
        
        self.content.groupList.dataSource = self
        self.content.groupList.delegate = self
        self.content.groupList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "groupCell")
        self.content.groupList.reloadData()
        
        let typeTag = PocketTagButton()
        typeTag.setTitle(lesson.type.rawValue, for: .normal)
        self.content.tagStack.addArrangedSubview(typeTag)
        
        for tag in lesson.tags {
            let lessonTag = PocketTagButton()
            lessonTag.setTitle(tag, for: .normal)
            self.content.tagStack.addArrangedSubview(lessonTag)
        }

    }
    
    func setNewUser(user : SAUsers.User){
        
        self.delegate?.didSetUser(user : user)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func backgroundUserLoad(user:SAUsers.User){
        DispatchQueue.global(qos: .background).async {
            let _ = SASchedule.shared.load(for: user)
        }
    }
}
extension LessonInfoModalViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath)
        
        
        let group = self.lesson.groups[indexPath.item]
        let tagView = PocketTagButton()
        tagView.setTitle(group.Name, for: .normal)
		tagView.isActive = (group != self.curUser)
        tagView.addTarget(action: { (sender) in
            self.setNewUser(user: group)
        }, for: .touchUpInside)
        
        cell.addSubview(tagView)
        tagView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lesson.groups.count
    }
}
extension LessonInfoModalViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let group = self.lesson.groups[indexPath.item]
        let tagView = PocketTagButton()
        tagView.setTitle(group.Name, for: .normal)
        tagView.setNeedsLayout()
        tagView.layoutIfNeeded()
        
        let size = tagView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        return CGSize(width: size.width, height: 22)
    }
}

protocol  UserChangeDelegate {
    func didSetUser(user : SAUsers.User)
}
