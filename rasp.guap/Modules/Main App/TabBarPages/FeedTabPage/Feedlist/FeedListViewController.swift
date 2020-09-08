//
//  FeedListViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 29.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import SafariServices


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
			make.centerX.equalToSuperview()
			make.width.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualTo(self.loadIndicator.snp.top).offset(-15)
            
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
	
	func convertoToK(_ num:Int)->String{
		if num >= 1000 {
			return String(format: "%iК", num/1000)
		}
		if num > 500  {
			return String(format: "%.1fК", Float(num)/1000)
		}
		return "\(num)"
	}
	
    func addFeed(elements: [SAFeedElement]){
        for element in elements{
			
            let newsView = builNewsView(element: element)
            let div = PocketDivView(content: newsView)
			let tapContainer = PocketScalableContainer(content: div)
			tapContainer.addTarget(action: { _ in
				let config = SFSafariViewController.Configuration()
				print("url: \(element.postUrl)")
				guard let url = URL(string: element.postUrl) else {return}
				let vc = SFSafariViewController(url: url, configuration: config)
				self.present(vc, animated: true, completion: nil)
			}, for: .touchUpInside)
            self.stackView.addArrangedSubview(tapContainer)
        }

    }
	private func builNewsView(element:SAFeedElement) -> PocketNewsView{
		let newsView = PocketNewsView(big: true)
		newsView.authorLabel.text = self.stream.source.name
		newsView.titleLabel.text = element.title
		
		newsView.likeLabel.text = "\(convertoToK(element.likes))"
		newsView.viewsLabel.text = "\(convertoToK(element.views))"
		newsView.repostLabel.text = "\(convertoToK(element.reposts))"
		newsView.commentLabel.text = "\(convertoToK(element.comments))"
		
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "Ru")
		
		formatter.dateFormat = "dd MMMM YYYY в HH:mm"
		newsView.datetimeLabel.text = formatter.string(from: element.date)
		
		NetworkManager.dataTask(url: element.imageURL ?? "") { (result) in
			switch(result){
				case .success(let data):
					guard let image = UIImage(data: data) else{ return }
					DispatchQueue.main.async{ newsView.imageView.image = image}
					break
				case .failure: break
			}
		}
		return newsView
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
