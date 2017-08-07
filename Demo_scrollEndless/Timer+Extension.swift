//
//  Timer+Extension.swift
//  Demo_scrollEndless
//
//  Created by 黄启明 on 2017/8/3.
//  Copyright © 2017年 Himin. All rights reserved.
//

import Foundation

extension Timer {
    
    func pause() {
        if self.isValid {
            self.fireDate = Date.distantFuture
        }
    }
    
    func restart() {
        if self.isValid {
            self.fireDate = Date()
        }
    }
    
    func restartAfterTimeInterval(_ interval: TimeInterval) {
        if self.isValid {
            self.fireDate = Date(timeIntervalSinceNow: interval)
        }
    }
    
}
