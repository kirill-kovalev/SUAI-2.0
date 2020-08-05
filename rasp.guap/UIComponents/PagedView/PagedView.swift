//
//  PagedView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PagedView : UIView, UIScrollViewDelegate{
    var delegate : PagedViewDelegate?
    
    private let scrollView:UIScrollView = {
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
    
    private let container: UIStackView = {
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
        pageControl.addTarget(self, action: #selector(self.pageControlHandler(_:)), for: .touchUpInside)
        
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
        container.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.height.equalToSuperview()
        }
        
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
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalTo(self.scrollView).multipliedBy(self.pageControl.numberOfPages+1)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = Int(pageNumber)
        self.delegate?.pagedViewDidChanged(Int(pageNumber))
    }
    @objc private func pageControlHandler(_ sender:UIPageControl){
        let pageNumber = sender.currentPage
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: Int(self.scrollView.frame.size.width) * pageNumber, y: 0)
        }
        self.delegate?.pagedViewDidChanged(pageNumber)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

