//
//  MCRefreshStateHeader.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/14.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

typealias MCLastUpdatedTimeText = (NSDate?) -> String

class MCRefreshStateHeader: MCRefreshHeader {
    
    var lastUpdatedTimeText: MCLastUpdatedTimeText?
    
    lazy var lastUpdatedTimeLabel = UILabel.label()
    lazy var stateLabel = UILabel.label()
    
    private var stateTitles = [MCRefreshState: String]()
    
    override func prepare() {
        super.prepare()
        
        self.addSubview(stateLabel)
        self.addSubview(lastUpdatedTimeLabel)
        
        self.setTitle(MCRefreshConst.HeaderIdleText, forState: .Idle)
        self.setTitle(MCRefreshConst.HeaderPullingText, forState: .Pulling)
        self.setTitle(MCRefreshConst.HeaderRefreshingText, forState:  .Refreshing)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if stateLabel.hidden {
            return
        }
        
        if direction == .Vertical {
            if lastUpdatedTimeLabel.hidden {
                stateLabel.frame = self.bounds;
            } else {
                // 状态
                stateLabel.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height * 0.5)
                // 更新时间
                lastUpdatedTimeLabel.frame = CGRect(x: 0, y: stateLabel.height, width: self.width, height: self.height - stateLabel.height)
            }
        } else if direction == .Horizontal {
            if lastUpdatedTimeLabel.hidden {
                stateLabel.frame = self.bounds;
            } else {
                // 状态
                stateLabel.frame = CGRect(x: 0, y: -54, width: self.width * 0.5, height: self.height)
                stateLabel.transform = CGAffineTransformMakeRotation(CGFloat(3 * M_PI_2))
                // 更新时间
                lastUpdatedTimeLabel.frame = CGRect(x: stateLabel.width, y: -54, width: self.width - stateLabel.width, height: self.height)
                lastUpdatedTimeLabel.transform = CGAffineTransformMakeRotation(CGFloat(3 * M_PI_2))
            }
        }
        

    }
    
    override var state: MCRefreshState {
        set {
            if state == newValue {
                return
            }
            super.state = newValue
            
            stateLabel.text = stateTitles[newValue]
            setLastUpdatedTimeLabelWithTimeKey(lastUpdatedTimeKey)
        }
        get {
            return super.state
        }
    }
    
    func setLastUpdatedTimeLabelWithTimeKey(timeKey: String) {
        lastUpdatedTimeKey = timeKey
        
        let lastUpdatedTime = NSUserDefaults.standardUserDefaults().objectForKey(lastUpdatedTimeKey) as? NSDate
        
        if let lastUpdatedTimeText = lastUpdatedTimeText {
            lastUpdatedTimeLabel.text = lastUpdatedTimeText(lastUpdatedTime)
            return
        }
        
        if let time = lastUpdatedTime {
            let calendar = NSCalendar.currentCalendar()
            let unitFlags: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute]
            let cmp1 = calendar.components(unitFlags, fromDate: time)
            let cmp2 = calendar.components(unitFlags, fromDate: NSDate())
            
            let formatter = NSDateFormatter()
            if cmp1.day == cmp2.day {
                formatter.dateFormat = "今天 HH:mm"
            } else if cmp1.year == cmp2.year {
                formatter.dateFormat = "MM-dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let timeString = formatter.stringFromDate(time)
            lastUpdatedTimeLabel.text = "最后更新：" + timeString
        } else {
            lastUpdatedTimeLabel.text = "最后更新：无记录"
        }
    }
    
}

extension MCRefreshStateHeader {
    func setTitle(title: String?, forState state: MCRefreshState) {
        if let title = title {
            stateTitles[state] = title
            stateLabel.text = stateTitles[self.state]
        }
    }
}
