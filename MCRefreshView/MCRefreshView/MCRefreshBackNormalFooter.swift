//
//  MCRefreshBackNormalFooter.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/15.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

class MCRefreshBackNormalFooter: MCRefreshBackStateFooter {
    
    let arrowView = UIImageView(image: UIImage(named: "arrow"))
    var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .Gray {
        didSet {
            loadingView.activityIndicatorViewStyle = activityIndicatorViewStyle
            self.setNeedsDisplay()
        }
    }
    
    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func prepare() {
        super.prepare()
        
        self.addSubview(arrowView)
        loadingView.hidesWhenStopped = true
        self.addSubview(loadingView)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if let size = arrowView.image?.size {
            if direction == .Vertical {
                arrowView.size = size
            } else {
                arrowView.size = CGSize(width: size.height, height: size.width)
            }
        }
        
        var arrowCenterX = self.width * 0.5
        if !stateLabel.hidden && direction == .Vertical {
            arrowCenterX -= 100
        }
        var arrowCenterY = self.height * 0.5
        if !stateLabel.hidden && direction == .Horizontal {
            arrowCenterY += 40
        }
        arrowView.center = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        loadingView.frame = arrowView.frame
    }
    
    override var state: MCRefreshState {
        get {
            return super.state
        }
        set {
            if state == newValue {
                return
            }
            let oldState = state
            super.state = newValue
            if state == .Idle {
                if oldState == .Refreshing {
                    if direction == .Vertical {
                        arrowView.transform = CGAffineTransformMakeRotation(-CGFloat(M_PI))
                    } else if direction == .Horizontal {
                        arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2) + 0.000001)
                    }
                    
                    UIView.animateWithDuration(MCRefreshConst.SlowDuration, animations: { () -> Void in
                        self.loadingView.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            self.loadingView.alpha = 1.0
                            self.loadingView.stopAnimating()
                            self.arrowView.hidden = false
                    })
                } else {
                    arrowView.hidden = false
                    loadingView.stopAnimating()
                    UIView.animateWithDuration(MCRefreshConst.FastDuration, animations: { () -> Void in
                        if self.direction == .Vertical {
                            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - CGFloat(M_PI))
                        } else if self.direction == .Horizontal {
                            self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2) + 0.000001)
                        }
                    })
                    
                }
            } else if state == .Pulling {
                arrowView.hidden = false
                loadingView.stopAnimating()
                UIView.animateWithDuration(MCRefreshConst.FastDuration, animations: { () -> Void in
                    if self.direction == .Vertical {
                        self.arrowView.transform = CGAffineTransformMakeRotation(-0.000001)
                    } else if self.direction == .Horizontal {
                        self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(3 * M_PI_2))
                    }
                })                
            } else if state == .Refreshing {
                arrowView.hidden = true
                loadingView.startAnimating()
            } else if state == .NoMoreData {
                arrowView.hidden = true
                loadingView.stopAnimating()
            }
        }
    }
}
