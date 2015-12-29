//
//  MCRefreshConst.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/14.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

struct MCRefreshConst {
    
    static let HeaderHeight: CGFloat = 54.0
    static let HeaderWidth: CGFloat = 60.0
    static let FooterHeight: CGFloat = 44.0
    static let FooterWidth: CGFloat = 44.0
    static let FastDuration = 0.25
    static let SlowDuration = 0.4
    
    static let ContentOffset = "contentOffset"
    static let ContentInset = "contentInset"
    static let ContentSize = "contentSize"
    
    static let PanState = "state"
    
    static let UpdatedTimeKey = "MCRefreshHeaderLastUpdatedTimeKey"
    
    static let HeaderIdleText = "下拉可以刷新"
    static let HeaderPullingText = "松开立即刷新"
    static let HeaderRefreshingText = "正在刷新数据中..."
    
    static let FooterIdleText = "上拉加载更多"
    static let FooterRefreshingText = "正在加载更多的数据..."
    static let FooterNoMoreDataText = "已经全部加载完毕"
    
    static let FooterPullingText = "松开立即加载更多"
    
}
