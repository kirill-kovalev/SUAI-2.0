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
        self._stream = .empty
        super.init(nibName: nil, bundle: nil)
    }
    init(stream:SAFeedStream){
        self._stream = stream
        super.init(nibName: nil, bundle: nil)
    }
    private var isLoading:Bool = false
    private var _stream:SAFeedStream
    var stream:SAFeedStream{
        get{
            self._stream
        }
        set{
            self._stream = newValue
            self.isLoading = false
            self.updateView()
        }
    }
    
    private var loadIndicator = UIActivityIndicatorView(frame: .zero)
    private var stackView:UIStackView =  {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.spacing = 18
        return stack
    }()
    private var scrollView:UIScrollView {self.view as! UIScrollView}
    
    override func loadView() {
        self.view = UIScrollView()
        self.scrollView.delegate = self
        
        self.scrollView.addSubview(self.stackView)
        self.scrollView.addSubview(self.loadIndicator)
        
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.contentLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
            make.bottom.lessThanOrEqualTo(self.loadIndicator.snp.top).offset(-15)
            make.width.equalToSuperview().inset(15)
        }
        loadIndicator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(40)
            make.bottom.equalTo(self.scrollView.contentLayoutGuide)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadIndicator.startAnimating()
    }
    func updateView(){
        self.stackView.arrangedSubviews.forEach{$0.removeFromSuperview()}
        DispatchQueue.global(qos: .background).async {
            self.isLoading = true
            let feed = self.stream.feed
            DispatchQueue.main.async {
                self.addFeed(elements: feed)
                self.isLoading = false
            }
        }
        
    }
    func addFeed(elements: [SAFeedElement]){
        for element in elements{
            let newsView = PocketNewsView()
            newsView.authorLabel.text = self.stream.source.name
            newsView.datetimeLabel.text = "\(element.date)"
            newsView.titleLabel.text = element.title
            
            let url = URL(string: element.imageURL ?? "")
            if url != nil {
                URLSession.shared.dataTask(with: url! ) { (data, resp, err) in
                    guard let data = data, let image = UIImage(data: data) else{ return }
                    DispatchQueue.main.async{ newsView.imageView.image = image}
                }.resume()
            }
            self.stackView.addArrangedSubview(PocketDivView(content: newsView))
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FeedListViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height <= (scrollView.contentOffset.y + scrollView.frame.height) {
            if !self.isLoading{
                DispatchQueue.global(qos: .background).async {
                    self.isLoading = true
                    let feed = self.stream.next()
                    DispatchQueue.main.async {
                        self.addFeed(elements: feed)
                        self.isLoading = false
                    }
                }
            }
        }
    }
}
