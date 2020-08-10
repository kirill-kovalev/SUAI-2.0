//
//  TimetableLessonCell.swift
//  rasp.guap
//
//  Created by Кирилл on 10.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TimetableLessonCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:style,reuseIdentifier:reuseIdentifier)
        let pocketLessonView = PocketDayView.fromNib()
        self.contentView.addSubview(pocketLessonView)
        pocketLessonView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
