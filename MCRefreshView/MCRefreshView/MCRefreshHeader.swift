//
//  MCRefreshHeader.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/14.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

class MCRefreshHeader: MCRefreshComponent {
    
    var ignoredScrollViewContentInsetTop: CGFloat = 0.0
    var lastUpdatedTimeKey = MCRefreshConst.UpdatedTimeKey
    var lastUpdatedTime: NSDate? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(lastUpdatedTimeKey) as? NSDate
        }
    }
    
    override func prepare() {
        super.prepare()
        
        if direction == .Vertical {
            self.height = MCRefreshConst.HeaderHeight
        } else if direction == .Horizontal {
            self.width = MCRefreshConst.HeaderWidth
        }
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if direction == .Vertical {
            self.y = -self.height - ignoredScrollViewContentInsetTop
        } else if direction == .Horizontal {
            self.x = -self.width - ignoredScrollViewContentInsetTop
        }
        
    }
    
    override func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        // 在刷新的refreshing状态
        if state == .Refreshing {
            // sectionheader停留解决
            return
        }
        
        scrollViewOriginalInset = scrollView!.contentInset
        
        if direction == .Vertical {
            let offsetY = scrollView!.offsetY
            let happenOffsetY = -scrollViewOriginalInset.top
            
            if offsetY > happenOffsetY {
                return
            }
            
            let normalPullingOffsetY = happenOffsetY - self.height
            let pullingPercent = (happenOffsetY - offsetY)/self.height
            if scrollView!.dragging {
                self.pullingPercent = pullingPercent
                if state == .Idle && offsetY < normalPullingOffsetY {
                    state = .Pulling
                } else if state == .Pulling && offsetY >= normalPullingOffsetY {
                    state = .Idle
                }
            } else if state == .Pulling {
                beginRefreshing()
            } else if pullingPercent < 1 {
                self.pullingPercent = pullingPercent
            }
        } else if direction == .Horizontal {
            let offsetX = scrollView!.offsetX
            let happenOffsetX = -scrollViewOriginalInset.left
            
            if offsetX > happenOffsetX {
                return
            }
            
            let normalPullingOffsetX = happenOffsetX - self.width
            let pullingPercent = (happenOffsetX - offsetX)/self.width
            if scrollView!.dragging {
                self.pullingPercent = pullingPercent
                if state == .Idle && offsetX < normalPullingOffsetX {
                    state = .Pulling
                } else if state == .Pulling && offsetX >= normalPullingOffsetX {
                    state = .Idle
                }
            } else if state == .Pulling {
                beginRefreshing()
            } else if pullingPercent < 1 {
                self.pullingPercent = pullingPercent
            }
        }
        
    }
    
    override var state: MCRefreshState {
        set {
            if state == newValue {
                return
            }
            let oldValue = super.state
            super.state = newValue
            if newValue == .Idle {
                if oldValue != .Refreshing {
                    return
                }
            
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: lastUpdatedTimeKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            
                UIView.animateWithDuration(MCRefreshConst.SlowDuration, animations: { () -> Void in
                    if self.direction == .Vertical {
                        self.scrollView?.insetTop -= self.height
                        
                    } else if self.direction == .Horizontal {
                        self.scrollView?.insetLeft -= self.width
                    }
                    
                    if self.automaticallyChangeAlpha {
                        self.alpha = 0.0
                    }
                }, completion: { (finished) -> Void in
                    self.pullingPercent = 0.0
                })
            } else if state == .Refreshing {
                UIView.animateWithDuration(MCRefreshConst.FastDuration, animations: { () -> Void in
                    if self.direction == .Vertical {
                        let top = self.scrollViewOriginalInset.top + self.height
                        self.scrollView?.insetTop = top
                        
                        self.scrollView?.offsetY = -top
                        
                    } else if self.direction == .Horizontal {
                        let left = self.scrollViewOriginalInset.left + self.width
                        self.scrollView?.insetLeft = left
                        
                        self.scrollView?.offsetX = -left
                    }

                }, completion: { (finished) -> Void in
                    self.executeRefreshingCallback()
                })
            }
        }
        get {
            return super.state
        }
    }
    
    override func endRefreshing() {
        if scrollView!.isKindOfClass(UICollectionView.classForCoder()) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                super.endRefreshing()
            }
        } else {
            super.endRefreshing()
        }
    }
    
}

extension MCRefreshHeader {
    convenience init(direction: MCRefreshDirection = .Vertical, refreshingClosure closure: MCRefreshingClosure) {
        self.init(direction: direction)
        self.refreshingClosure = closure
    }
}

