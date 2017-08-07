//
//  ViewController.swift
//  Demo_scrollEndless
//
//  Created by 黄启明 on 2017/8/3.
//  Copyright © 2017年 Himin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EndlessLoopScrollViewDelegate {
    
    var contentViewsDataArr: Array<UILabel> = Array<UILabel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray

        let colorArray = [UIColor.cyan, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.purple];
        
        for i in 0..<colorArray.count {
            let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 200))
            tempLabel.backgroundColor = colorArray[i]
            tempLabel.textAlignment = .center
            tempLabel.text = "\(i)"
            tempLabel.font = UIFont.systemFont(ofSize: 50)
            contentViewsDataArr.append(tempLabel)
        }
        
        let loopScrollView = EndlessLoopScrollView(frame: CGRect(x: 20, y: 100, width: 280, height: 200), animationScrollDuration: 1.5)
        loopScrollView.delegate = self
        
        view.addSubview(loopScrollView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - EndlessLoopScrollViewDelegate
    
    func numberOfContentViewsInLoopScrollView(_ loopScrollView: EndlessLoopScrollView) -> Int {
        return contentViewsDataArr.count
    }
    
    func loopScrollView(_ loopScrollView: EndlessLoopScrollView, contentViewAtIndex index: Int) -> UIView {
        return contentViewsDataArr[index]
    }
    
    func loopScrollView(_ loopScrollView: EndlessLoopScrollView, currentContentViewAtIndex index: Int) {
        print("currentIndex: \(index)")
    }
    
    func loopScrollView(_ loopScrollView: EndlessLoopScrollView, didSelectedContentViewAtIndex index: Int) {
        print("didSelectedAtIndex: \(index)")
    }
    
}

