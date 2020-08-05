//
//  PagedView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PagedView : UIView, UIScrollViewDelegate{
    
    let scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()

    let pageControl:UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        return pageControl;
    }()
    let container: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        return stack
    }()
    
    private var views = Array(repeating: UIView(), count: 0 );
    
    
    init() {
        
        super.init(frame: .zero)
        scrollView.delegate = self
        addViews()
        setupConstraints()
        
        
    }
    
    private func addViews(){
        super.addSubview(scrollView)
        super.addSubview(pageControl)
        self.scrollView.addSubview(container)
        
    }
    private func setupConstraints(){
        
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top)
        }
        pageControl.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15)
        }

        
    }
    
    func add(asChild childVC: UIViewController, of parentVC: UIViewController){
        
        self.addSubview(childVC.view)
//        childVC.view.frame = parentVC.view.bounds
//        childVC.didMove(toParent: parentVC)
        
    }
    
    override func addSubview(_ view: UIView) {
        self.container.addSubview(view)
        setupViewConstraints(view)
        self.views.append(view)
        pageControl.numberOfPages = self.views.count
        
    }
    
    private func setupViewConstraints(_ view: UIView){
        view.snp.makeConstraints { (make) in
            make.height.width.equalTo(self.scrollView)
            if views.last != nil {
                make.left.equalTo(views.last!.snp.right)
            }else{
                print(views)
                make.left.equalToSuperview()
            }
        }
        container.snp.remakeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView).multipliedBy(self.pageControl.numberOfPages+1)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = Int(pageNumber)
    }
    func updatesSize(){
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * CGFloat(self.pageControl.numberOfPages), height: self.scrollView.frame.height)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

