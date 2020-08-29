//
//  FeedListViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 29.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class FeedListViewController: UIViewController {
    init() {
        let news = SANews()
        news.loadSourceList()
        self._stream = news.get(index: 0)!
        super.init(nibName: nil, bundle: nil)
    }
    init(stream:SAFeedStream){
        self._stream = stream
        super.init(nibName: nil, bundle: nil)
    }
    
    private var _stream:SAFeedStream
    var stream:SAFeedStream{
        get{
            self._stream
        }
        set{
            self._stream = newValue
//            print("source: \(newValue.source)")
//            for e in newValue.feed{
//                print("\(e.title)")
//            }
            self.updateView()
        }
    }
    
    
    private var stackView:UIStackView =  {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.spacing = 18
        return stack
    }()
    private var scrollView:UIScrollView {self.view as! UIScrollView}
    override func loadView() {
        self.view = UIScrollView()
        self.scrollView.addSubview(self.stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.contentLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualTo(self.scrollView.contentLayoutGuide)
            make.width.equalToSuperview().inset(15)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func updateView(){
        self.stackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
        for element in self.stream.feed{
            let newsView = PocketNewsView()
            newsView.authorLabel.text = self.stream.source.name
            newsView.datetimeLabel.text = "\(element.date)"
            newsView.titleLabel.text = element.title
            let url = URL(string: element.imageURL ?? "")
            if url != nil {
                URLSession.shared.dataTask(with: url! ) { (data, resp, err) in
                    guard let data = data,
                        let image = UIImage(data: data) else{
                            return
                    }
                    DispatchQueue.main.async {
                        newsView.imageView.image = image
                    }
                    
                }.resume()
            }
            
            self.stackView.addArrangedSubview(PocketDivView(content: newsView))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
