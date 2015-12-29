//
//  ViewController.swift
//  MCRefreshView
//
//  Created by zhmch0329 on 15/12/14.
//  Copyright © 2015年 zhmch0329. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataSource = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let footer = MCRefreshBackNormalFooter()
        footer.refreshingClosure = { (header) in
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                self.reloadData()
                if self.dataSource.count > 33 {
                    footer.endRefreshingWithNoMoreData()
                } else {
                    footer.endRefreshing()
                }
            }
        }
        tableView.footer = footer
        
        let header = MCRefreshNormalHeader()
        header.refreshingClosure = {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                self.count = 0
                self.dataSource.removeAll()
                self.reloadData()
                footer.resetNoMoreData()
                header.endRefreshing()
            }
        }
        tableView.header = header
        

        tableView.header?.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var count = 0
    private var pageIndex = 1
    private func reloadData() {
        var array = [String]()
        for var i = count; i < pageIndex * 5; ++i {
            array.append("第\(i)行")
        }
        count += 5
        pageIndex++
        self.dataSource.appendContentsOf(array)
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Identifier: String = "Identifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(Identifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: Identifier)
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    

}

