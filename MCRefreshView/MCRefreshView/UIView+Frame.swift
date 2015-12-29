//
//  UIView+Frame.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/14.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    
    var size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    
    var origin: CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
}

extension UIScrollView {
    var insetTop: CGFloat {
        set {
            var inset = self.contentInset
            inset.top = newValue
            self.contentInset = inset
        }
        get {
            return self.contentInset.top
        }
    }
    var insetBottom: CGFloat {
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            self.contentInset = inset
        }
        get {
            return self.contentInset.bottom
        }
    }
    var insetLeft: CGFloat {
        set {
            var inset = self.contentInset
            inset.left = newValue
            self.contentInset = inset
        }
        get {
            return self.contentInset.left
        }
    }
    var insetRight: CGFloat {
        set {
            var inset = self.contentInset
            inset.right = newValue
            self.contentInset = inset
        }
        get {
            return self.contentInset.right
        }
    }
    
    var offsetX: CGFloat {
        set {
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.x
        }
    }
    var offsetY: CGFloat {
        set {
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.y
        }
    }
    
    var contentWidth: CGFloat {
        set {
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
        get {
            return self.contentSize.width
        }
    }
    var contentHeight: CGFloat {
        set {
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
        get {
            return self.contentSize.height
        }
    }
    
}






