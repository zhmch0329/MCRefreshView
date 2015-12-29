//
//  ViewController1.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/14.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

class ViewController1: UIViewController, UICollectionViewDataSource {

    var dataSource = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerClass(CollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Identifier")
        
        let footer = MCRefreshBackNormalFooter()
        footer.refreshingClosure = {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                self.reloadData()
                if self.dataSource.count > 33 {
                    footer.endRefreshingWithNoMoreData()
                } else {
                    footer.endRefreshing()
                }
            }
        }
        collectionView.footer = footer
        
        let header = MCRefreshNormalHeader()
        header.refreshingClosure = {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                self.dataSource.removeAll()
                self.reloadData()
                footer.resetNoMoreData()
                header.endRefreshing()
            }
        }
        collectionView.header = header
        
        
        collectionView.header.beginRefreshing()
    }
    
    private func reloadData() {
        var array = [String]()
        for var i = self.dataSource.count; i < self.dataSource.count + 10; ++i {
            array.append("第\(i)行")
        }
        
        self.dataSource.appendContentsOf(array)
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Identifier", forIndexPath: indexPath) as! CollectionViewCell
        cell.label.text = dataSource[indexPath.row]
        return cell
    }
}
