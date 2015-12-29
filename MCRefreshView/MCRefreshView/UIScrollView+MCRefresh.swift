//
//  UIScrollView+MCRefresh.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/14.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

extension NSObject {
    class func exchangeInstanceMethod1(method1: Selector, method2: Selector) {
        method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2))
    }
    
    class func exchangeClassMethod1(method1: Selector, method2: Selector) {
        method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2))
    }
}

private var HeaderAssociationKey: UInt8 = 29
private var FooterAssociationKey: UInt8 = 13
private var ReloadDataClosureAssociationKey: UInt8 = 27

extension UIScrollView {
    
    var header: MCRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &HeaderAssociationKey) as? MCRefreshHeader
        }
        set(newValue) {
            if header != newValue {
                if header != nil {
                    header!.removeFromSuperview()
                }
                
                if newValue != nil {
                    self.addSubview(newValue!)
                }
                objc_setAssociatedObject(self, &HeaderAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var footer: MCRefreshFooter! {
        get {
            return objc_getAssociatedObject(self, &FooterAssociationKey) as? MCRefreshFooter
        }
        set(newValue) {
            if footer != newValue {
                if footer != nil {
                    footer.removeFromSuperview()
                }
                
                self.addSubview(newValue)
                objc_setAssociatedObject(self, &FooterAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var totalDataCount: Int {
        var totalCount = 0
        if self.isKindOfClass(UITableView.classForCoder()) {
            let tableView = self as! UITableView
            for var section = 0; section < tableView.numberOfSections; ++section {
                totalCount += tableView.numberOfRowsInSection(section)
            }
        } else if self.isKindOfClass(UICollectionView.classForCoder()) {
            let collectionView = self as! UICollectionView
            for var section = 0; section < collectionView.numberOfSections(); ++section {
                totalCount += collectionView.numberOfItemsInSection(section)
            }
        }
        return totalCount
    }
    
    var reloadDataClosure: ((Int) -> Void)? {
        get {
            return self.reloadDataClosure
//            return objc_getAssociatedObject(self, &ReloadDataClosureAssociationKey) as? (Int) -> Void
        }
        set(newValue) {
            self.reloadDataClosure = newValue
//            objc_setAssociatedObject(self, &ReloadDataClosureAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var isHeaderRefreshing: Bool? {
        return header?.isRefreshing()
    }
}


extension UITableView {
    func mcReloadData() {
        self.mcReloadData()
        
        
    }
    
    
}