//
//  MCRefreshComponent.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/14.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

enum MCRefreshDirection {
    // 垂直 & 水平
    case Vertical, Horizontal
}

enum MCRefreshState {
    case Idle, Pulling, Refreshing, WillRefresh, NoMoreData
}

typealias MCRefreshingClosure = () -> Void

class MCRefreshComponent: UIView {
    
    // MARK: - Private Property
    // 记录scrollView刚开始的inset
    var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsetsZero
    // 父控件
    weak var scrollView: UIScrollView?
    
    // MARK: - Refreshing Callback
    // 正在刷新的回调
    var refreshingClosure: MCRefreshingClosure?
    // 状态
    var state = MCRefreshState.Pulling
    // 方向
    var direction = MCRefreshDirection.Vertical 
    
    // pan Gesture Recognizer
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    // 拉拽的百分比(交给子类重写)
    var pullingPercent: CGFloat = 1.0
    // 根据拖拽比例自动切换透明度
    var automaticallyChangeAlpha: Bool = false {
        didSet {
            if isRefreshing() {
                return
            }
            if automaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }
    
    // MARK: init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    init() {
        super.init(frame: CGRectZero)
        prepare()
    }
    
    init(direction: MCRefreshDirection) {
        super.init(frame: CGRectZero)
        self.direction = direction
        prepare()
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: override method
    override func layoutSubviews() {
        super.layoutSubviews()
        placeSubviews()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let superView = newSuperview {
            guard superView.isKindOfClass(UIScrollView.classForCoder()) else {
                return
            }
            removeObservers()
            
            if direction == .Vertical {
                self.width = superView.width
                self.x = 0
            } else if direction == .Horizontal {
                self.height = superView.height
                self.y = 0
            }
            
            scrollView = superView as? UIScrollView
            scrollView?.alwaysBounceVertical = direction == .Vertical
            scrollView?.alwaysBounceHorizontal = direction == .Horizontal
            
            scrollViewOriginalInset = scrollView!.contentInset
            
            state = .Idle
            
            addObservers()
        } else {
            removeObservers()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if state == .WillRefresh {
            state = .Refreshing
        }
    }
    
    // MARK: KVO
    private func addObservers() {
        let options: NSKeyValueObservingOptions = [.New, .Old]
        scrollView?.addObserver(self, forKeyPath: MCRefreshConst.ContentOffset, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: MCRefreshConst.ContentSize, options: options, context: nil)
        panGestureRecognizer = self.scrollView?.panGestureRecognizer
        panGestureRecognizer?.addObserver(self, forKeyPath: MCRefreshConst.PanState, options: options, context: nil)
    }
    
    private func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: MCRefreshConst.ContentOffset)
        self.superview?.removeObserver(self, forKeyPath: MCRefreshConst.ContentSize)
        panGestureRecognizer?.removeObserver(self, forKeyPath: MCRefreshConst.PanState)
        panGestureRecognizer = nil
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard self.userInteractionEnabled else {
            return
        }
        
        if keyPath == MCRefreshConst.ContentSize {
            scrollViewContentSizeDidChange(change)
        }
        
        guard !self.hidden else {
            return
        }
        
        if keyPath == MCRefreshConst.ContentOffset {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == MCRefreshConst.PanState {
            scrollViewPanStateDidChange(change)
        }
    }
    
    func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        
    }
    
    func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        
    }
    
    func scrollViewPanStateDidChange(change: [String : AnyObject]?) {
        
    }
    
}

// MARK: - subview achieve
extension MCRefreshComponent {
    func prepare() {
        // 基本属性
        if direction == .Vertical {
            self.autoresizingMask = .FlexibleWidth
        } else {
            self.autoresizingMask = .FlexibleHeight
        }
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    func placeSubviews() {

    }
    

}

// MARK: - subview override
extension MCRefreshComponent {
    
}

// MARK: - Public method
extension MCRefreshComponent {
    func beginRefreshing() {
        UIView.animateWithDuration(MCRefreshConst.FastDuration) { () -> Void in
            self.alpha = 1.0
        }
        pullingPercent = 1.0
        if (self.window != nil) {
            state = .Refreshing
        } else {
            state = .WillRefresh
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            self.setNeedsDisplay()
        }
    }
    
    func endRefreshing() {
        state = .Idle
    }
    
    func isRefreshing() -> Bool {
        return (state == .Refreshing)||(state == .WillRefresh)
    }
    
    func executeRefreshingCallback() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let refreshingClosure = self.refreshingClosure {
                refreshingClosure()
            }
        }
    }
}

extension UILabel {
    class func label() -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(14.0)
        label.textColor = UIColor(white: 0.4, alpha: 1.0)
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        return label;
    }
}
























