//
//  MCRefreshFooter.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/15.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

class MCRefreshFooter: MCRefreshComponent {
    
    var automaticallyHidden: Bool = true
    
    override func prepare() {
        super.prepare()
        
        if direction == .Vertical {
            self.height = MCRefreshConst.FooterHeight
        } else if direction == .Horizontal {
            self.width = MCRefreshConst.FooterWidth
        }
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if let _ = newSuperview {
            // 监听scrollView数据的变化
            
        }
    }
    
    override func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentSizeDidChange(change)
        
        if scrollView?.totalDataCount == 0 {
            self.hidden = automaticallyHidden
        } else {
            self.hidden = false
        }
    }
    
    func endRefreshingWithNoMoreData() {
        state = .NoMoreData
    }
    
    func resetNoMoreData() {
        state = .Idle
    }
    
}

extension MCRefreshFooter {
    convenience init(direction: MCRefreshDirection = .Vertical, refreshingClosure closure: MCRefreshingClosure) {
        self.init(direction: direction)
        self.refreshingClosure = closure
    }
}
