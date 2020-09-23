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


class FeedListViewController: UITableViewController {
    init() {
        self._stream = .empty
        super.init(style: .plain)
    }
    init(stream:SAFeedStream){
        self._stream = stream
		super.init(style: .plain)
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
    
    
	//private var images:[IndexPath:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.register(FeedTableCell.self, forCellReuseIdentifier: "newsCell")
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 500;
		tableView.backgroundColor = .clear
		tableView.separatorStyle = .none
    }
    func updateView(){
		self.tableView.reloadData()
        DispatchQueue.global(qos: .background).async {
            self.isLoading = true
			if self.stream.feed.isEmpty {self.stream.reload()}
            DispatchQueue.main.async {
				self.tableView.reloadData()
				self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                self.isLoading = false
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height <= (scrollView.contentOffset.y + scrollView.frame.height) {
            if !self.isLoading{
                DispatchQueue.global(qos: .background).async {
                    self.isLoading = true
                    let _ = self.stream.next()
                    DispatchQueue.main.async {
						self.tableView.reloadData()
                        self.isLoading = false
                    }
                }
            }
        }
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (indexPath.row == self.stream.feed.count ){
			let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
			let indicator = PocketActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
			indicator.startAnimating()
			cell.contentView.addSubview(indicator)
			indicator.snp.makeConstraints { (make) in
				make.height.width.equalTo(45)
				make.top.equalToSuperview().offset(15)
				make.bottom.equalToSuperview().inset(15)
				make.centerX.equalToSuperview()
			}
			cell.contentView.backgroundColor = .clear
			cell.backgroundColor = .clear
			cell.setNeedsUpdateConstraints()
			cell.updateConstraintsIfNeeded()
			return cell
		}
		NetworkManager.dataTask(url: self.stream.feed[indexPath.row].imageURL ?? "") { (result) in
			switch(result){
				case .success(let data):
					guard let image = UIImage(data: data) else{ return }
					DispatchQueue.main.async{
						(tableView.cellForRow(at: indexPath) as? FeedTableCell)?.newsView.imageView.image = image
					}
					break
				case .failure: break
			}
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! FeedTableCell
		cell.setupView(element: self.stream.feed[indexPath.row])
		cell.setNeedsUpdateConstraints()
		cell.updateConstraintsIfNeeded()
		cell.container.addTarget(action: { (_) in
						let config = SFSafariViewController.Configuration()
			guard let url = URL(string: self.stream.feed[indexPath.row].postUrl) else {return}
						let vc = SFSafariViewController(url: url, configuration: config)
						vc.modalPresentationStyle = .popover
						self.present(vc, animated: true, completion: nil)
		}, for: .touchUpInside)
		return cell
		
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.stream.feed.count+1
	}
	
}







class FeedTableCell:UITableViewCell{
	let newsView:PocketNewsView = PocketNewsView(big: true)
	lazy var container = PocketScalableContainer(content: PocketDivView(content: newsView))
	private var url:String = ""
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		initSetup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initSetup()
	}
	private func initSetup(){
		print("init setup")
		self.backgroundColor = .clear
		self.contentView.addSubview(container)
		container.snp.makeConstraints { (make) in
			make.width.height.equalToSuperview().inset(10)
			make.center.equalToSuperview()
		}
	}

	private func convertoToK(_ num:Int)->String{
		if num > 999 {
			return String(format: "%.1fК", Float(num)/1000)
		}else{
			return "\(num)"
		}
	}
	
	
	
	func setupView(element:SAFeedElement){
		self.contentView.addSubview(container)
		newsView.authorLabel.text = element.source.name
		newsView.titleLabel.text = element.title
		
		newsView.likeLabel.text = "\(convertoToK(element.likes))"
		newsView.viewsLabel.text = "\(convertoToK(element.views))"
		newsView.repostLabel.text = "\(convertoToK(element.reposts))"
		newsView.commentLabel.text = "\(convertoToK(element.comments))"
		self.newsView.imageView.image = nil
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "Ru")
		
		formatter.dateFormat = "dd MMMM YYYY в HH:mm"
		newsView.datetimeLabel.text = formatter.string(from: element.date)

	}
}
