//
//  ProductsTableViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 13/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    var productNames: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productNames = ["1907 Wall Set", "1921 Dial Phone", "1937 Desk Set", "1984 Motorola"]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "ShowProduct"){
            let productVC:ProductViewController = segue.destinationViewController as! ProductViewController
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) else {
                return
            }
            productVC.productName = productNames?[indexPath.row]
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let pNames = productNames{
            return pNames.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as UITableViewCell
        
        let productName = productNames?[indexPath.row]
            
        if let pName = productName{
            cell.textLabel?.text = pName
        }
        
        cell.imageView?.image = UIImage(named: "image-cell1")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
