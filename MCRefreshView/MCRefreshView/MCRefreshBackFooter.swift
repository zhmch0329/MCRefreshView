//
//  MCRefreshBackFooter.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/15.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

class MCRefreshBackFooter: MCRefreshFooter {
    
    private var lastRefreshCount = 0
    private var lastDelta: CGFloat = 0.0
    
    // igored scrollview contentInset: Vertical--Bottom, Horizontal--Right
    var ignoredScrollViewContentInset: CGFloat = 0.0
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if let _ = newSuperview {
            scrollViewContentSizeDidChange(nil)
        }
    }
    
    private func refreshingOffset() -> CGFloat {
        let deltaSide = heightForContentBreakView()
        var inset: CGFloat = 0.0
        if direction == .Vertical {
            inset = scrollViewOriginalInset.top
        } else if direction == .Horizontal {
            inset = scrollViewOriginalInset.right
        }
        if deltaSide > 0 {
            return deltaSide - inset
        } else {
            return -inset
        }
    }
    
    private func heightForContentBreakView() -> CGFloat {
        if direction == .Vertical {
            let h = scrollView!.height - scrollViewOriginalInset.bottom - scrollViewOriginalInset.top
            return scrollView!.contentHeight - h
        } else if direction == .Horizontal {
            let w = scrollView!.width - scrollViewOriginalInset.left - scrollViewOriginalInset.right
            return scrollView!.contentWidth - w
        }
        return 0
    }
    
    // MARK: - override super class method
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        if state == .Refreshing || self.hidden {
            return
        }
        
        scrollViewOriginalInset = scrollView!.contentInset
        
        if direction == .Vertical {
            // current contentOffset.y
            let offsetY = scrollView!.offsetY
            // trigger refreshing offset y value
            let happenOffsetY = refreshingOffset()
            // if drop down, return
            if offsetY <= happenOffsetY {
                return
            }
            
            let pullingPercent = (offsetY - happenOffsetY)/self.height
            
            if state == .NoMoreData {
                self.pullingPercent = pullingPercent
                return
            }
            
            if scrollView!.dragging {
                self.pullingPercent = pullingPercent
                
                let normalPullingOffsetY = happenOffsetY + self.height
                if state == .Idle && offsetY > normalPullingOffsetY {
                    state = .Pulling
                } else if state == .Pulling && offsetY <= normalPullingOffsetY {
                    state = .Idle
                }
            } else if state == .Pulling {
                beginRefreshing()
            } else if pullingPercent < 1 {
                self.pullingPercent = pullingPercent
            }
        } else if direction == .Horizontal {
            let offsetX = scrollView!.offsetX
            let happenOffsetX = refreshingOffset()
            
            if offsetX <= happenOffsetX {
                return
            }
            
            let pullingPercent = (offsetX - happenOffsetX)/self.width
            
            if state == .NoMoreData {
                self.pullingPercent = pullingPercent
                return
            }
            
            if scrollView!.dragging {
                self.pullingPercent = pullingPercent
                
                let normalPullingOffsetX = happenOffsetX + self.width
                if state == .Idle && offsetX > normalPullingOffsetX {
                    state = .Pulling
                } else if state == .Pulling && offsetX <= normalPullingOffsetX {
                    state = .Idle
                }
            } else if state == .Pulling {
                beginRefreshing()
            } else if pullingPercent < 1 {
                self.pullingPercent = pullingPercent
            }
        }
    }
    
    override func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentSizeDidChange(change)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(MCRefreshConst.SlowDuration * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            if self.direction == .Vertical {
                let contentHeight = self.scrollView!.contentHeight + self.ignoredScrollViewContentInset
                let scrollHeight = self.scrollView!.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInset
                self.y = max(contentHeight, scrollHeight)
            } else if self.direction == .Horizontal {
                let contentWidth = self.scrollView!.contentWidth + self.ignoredScrollViewContentInset
                let scrollWidth = self.scrollView!.width - self.scrollViewOriginalInset.left - self.scrollViewOriginalInset.right + self.ignoredScrollViewContentInset
                self.x = max(contentWidth, scrollWidth)
            }
        })
    }
    
    override var state: MCRefreshState {
        get {
            return super.state
        }
        set {
            if state == newValue {
                return
            }
            let oldValue = super.state
            super.state = newValue
            if newValue == .Idle || state == .NoMoreData {
                if oldValue == .Refreshing {
                    UIView.animateWithDuration(MCRefreshConst.SlowDuration, animations: { () -> Void in
                        if self.direction == .Vertical {
                            self.scrollView?.insetBottom -= self.lastDelta
                        } else if self.direction == .Horizontal {
                            self.scrollView?.insetRight -= self.lastDelta
                        }
                        
                        if self.automaticallyChangeAlpha {
                            self.alpha = 0.0
                        }
                        }, completion: { (finished) -> Void in
                            self.pullingPercent = 0
                    })
                }
                let delta = heightForContentBreakView()
                if oldValue == .Refreshing && delta > 0 && scrollView?.totalDataCount != lastRefreshCount {
                    if direction == .Vertical {
                        scrollView?.offsetY = scrollView!.offsetY
                    } else if direction == .Horizontal {
                        scrollView?.offsetX = scrollView!.offsetX
                    }
                }
            } else if state == .Refreshing {
                lastRefreshCount = scrollView!.totalDataCount
                UIView.animateWithDuration(MCRefreshConst.FastDuration, animations: { () -> Void in
                    if self.direction == .Vertical {
                        var bottom = self.height + self.scrollViewOriginalInset.bottom
                        let deltaH = self.heightForContentBreakView()
                        if deltaH < 0 {
                            bottom -= deltaH
                        }
                        self.lastDelta = bottom - self.scrollView!.insetBottom
                        self.scrollView?.insetBottom = bottom
                        self.scrollView?.offsetY = self.refreshingOffset() + self.height
                    } else if self.direction == .Horizontal {
                        var right = self.width + self.scrollViewOriginalInset.right
                        let deltaW = self.heightForContentBreakView()
                        if deltaW < 0 {
                            right -= deltaW
                        }
                        self.lastDelta = right - self.scrollView!.insetRight
                        self.scrollView?.insetRight = right
                        self.scrollView?.offsetX = self.refreshingOffset() + self.width
                    }
                    
                    }, completion: { (finished) -> Void in
                        self.executeRefreshingCallback()
                })
            }

        }
    }
}

extension MCRefreshBackFooter {
    override func endRefreshing() {
        if scrollView!.isKindOfClass(UICollectionView.classForCoder()) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                super.endRefreshing()
            })
        } else {
            super.endRefreshing()
        }
    }
    
    override func endRefreshingWithNoMoreData() {
        if scrollView!.isKindOfClass(UICollectionView.classForCoder()) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                super.endRefreshingWithNoMoreData()
            })
        } else {
            super.endRefreshingWithNoMoreData()
        }
    }
    
}

