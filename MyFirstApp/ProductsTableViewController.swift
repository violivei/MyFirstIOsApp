//
//  ProductsTableViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 13/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "Hello friend."
        cell.imageView?.image = UIImage(named: "image-cell1")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
