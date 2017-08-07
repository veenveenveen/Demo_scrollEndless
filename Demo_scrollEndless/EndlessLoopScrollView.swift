//
//  EndlessLoopScrollView.swift
//  Demo_scrollEndless
//
//  Created by 黄启明 on 2017/8/3.
//  Copyright © 2017年 Himin. All rights reserved.
//

import UIKit

protocol EndlessLoopScrollViewDelegate {
    
    func numberOfContentViewsInLoopScrollView(_ loopScrollView: EndlessLoopScrollView) -> Int
    
    func loopScrollView(_ loopScrollView: EndlessLoopScrollView, contentViewAtIndex index: Int) -> UIView
    
    func loopScrollView(_ loopScrollView: EndlessLoopScrollView, currentContentViewAtIndex index: Int)
    
    func loopScrollView(_ loopScrollView: EndlessLoopScrollView, didSelectedContentViewAtIndex index: Int)
//
}

class EndlessLoopScrollView: UIView, UIScrollViewDelegate {
    
    var delegate: EndlessLoopScrollViewDelegate! {
        didSet {
            reloadData()
        }
    }
    
    var scrollView: UIScrollView!
    var totalPageCount: Int!
    var currentPageIndex: Int!
    
    var timer: Timer!
    var animationDuration: TimeInterval!
    
    ///page control
    var pageControl: UIPageControl!
    
    init(frame: CGRect, animationScrollDuration: TimeInterval) {
        super.init(frame: frame)
                
        backgroundColor = UIColor.orange
        
        initData()
        initAnimationTimerWith(scrollDuration: animationScrollDuration)
        setupScrollView()
        setupPageControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initData() {
        timer = nil
        animationDuration = 0
    }
    
    fileprivate func initAnimationTimerWith(scrollDuration: TimeInterval) {
        animationDuration = scrollDuration
        if scrollDuration > 0 {
            ///
            timer = Timer.scheduledTimer(withTimeInterval: scrollDuration, repeats: true, block: { (timer) in
                ///
                self.startScroll()
            })
            
            RunLoop.main.add(timer, forMode: .commonModes)
            timer.pause()
        }
    }
    /// setup scrollView
    fileprivate func setupScrollView() {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: width * 3, height: height)
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        
        addSubview(scrollView)
    
    }
    /// setup pageControl
    fileprivate func setupPageControl() {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: height - 37, width: width, height: 37))
        pageControl.numberOfPages = 0
        
        addSubview(pageControl)
    }
    
    fileprivate func startScroll() {
        ///
        let contentOffsetX = scrollView.contentOffset.x + scrollView.frame.size.width
        let newOffset = CGPoint(x: contentOffsetX, y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
    }
    
    ///
    fileprivate func reloadData() {
        currentPageIndex = 0
        totalPageCount = delegate.numberOfContentViewsInLoopScrollView(self)
        pageControl.numberOfPages = delegate.numberOfContentViewsInLoopScrollView(self)
        
        resetContentViews()
        
        timer.restartAfterTimeInterval(animationDuration)
        
    }
    
    fileprivate func resetContentViews() {
        
        if scrollView.subviews.count > 0 {
            for subview in scrollView.subviews {
                subview.removeFromSuperview()
            }
        }
        
        let previousIndex = getPreviousPageIndexWith(currentPageIndex: currentPageIndex)
        let currentIndex = currentPageIndex!
        let nextIndex = getNextPageIndexIndexWith(currentPageIndex: currentPageIndex)
        
        let previousContentView: UIView = delegate.loopScrollView(self, contentViewAtIndex: previousIndex)
        let currentContentView: UIView = delegate.loopScrollView(self, contentViewAtIndex: currentIndex)
        let nextContentView: UIView = delegate.loopScrollView(self, contentViewAtIndex: nextIndex)
        
        var viewArr: Array = [previousContentView, currentContentView, nextContentView]
        
        
        for i in 0..<viewArr.count {
            let contentView = viewArr[i]
            contentView.frame = CGRect(x: frame.size.width * CGFloat(i), y: 0, width: frame.size.width, height: frame.size.height)
            contentView.isUserInteractionEnabled = true
            
            //添加点击手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapContentView))
            contentView.addGestureRecognizer(tapGesture)
            
            scrollView.addSubview(contentView)
        }
        
        scrollView.contentOffset = CGPoint(x: frame.size.width, y: 0)
        
    }
    
    func tapContentView() {
        delegate.loopScrollView(self, didSelectedContentViewAtIndex: currentPageIndex)
    }
    
    //MARK: -  UIScrollView Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //手动滑动时 暂停计时器
        timer.pause()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //手动滑动结束 开启定时器
        timer.restartAfterTimeInterval(animationDuration)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //页面滚动
//        print("...")
        let contentOffsetX = scrollView.contentOffset.x
        
        if contentOffsetX >= frame.size.width * 2 {
            currentPageIndex = getNextPageIndexIndexWith(currentPageIndex: currentPageIndex)
            delegate.loopScrollView(self, currentContentViewAtIndex: currentPageIndex)
            pageControl.currentPage = currentPageIndex
                
            resetContentViews()
        }
        
        if contentOffsetX <= 0 {
            currentPageIndex = getPreviousPageIndexWith(currentPageIndex: currentPageIndex)
            delegate.loopScrollView(self, currentContentViewAtIndex: currentPageIndex)
            pageControl.currentPage = currentPageIndex
            
            resetContentViews()
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: frame.size.width, y: 0), animated: true)
    }
    
    ///
    // 获取当前页上一页的序号
    fileprivate func getPreviousPageIndexWith(currentPageIndex: Int) -> Int {
        return currentPageIndex == 0 ? totalPageCount - 1 : currentPageIndex - 1
    }
    // 获取当前页下一页的序号
    fileprivate func getNextPageIndexIndexWith(currentPageIndex: Int) -> Int {
        return currentPageIndex == totalPageCount - 1 ? 0 : currentPageIndex + 1
    }

}
