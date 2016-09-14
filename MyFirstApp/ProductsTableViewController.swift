//
//  ProductsTableViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 13/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColorFromRGB(0x002E10)
        
        let product1 = Product()
        let product2 = Product()
        let product3 = Product()
        let product4 = Product()
        let product5 = Product()
        let product6 = Product()
        let product7 = Product()
        
        product1.name = "1907 Wall Set"
        product1.productImage = "phone-fullscreen1"
        product1.cellImage = "draught"
        
        product2.name = "1921 Dial Phone"
        product2.productImage = "phone-fullscreen2"
        product2.cellImage = "the-icon"
        
        product3.name = "1937 Desk Set"
        product3.productImage = "phone-fullscreen3"
        product3.cellImage = "the-can"
        
        product4.name = "1984 Motorola"
        product4.productImage = "phone-fullscreen4"
        product4.cellImage = "extra-cold"
        
        product5.name = "1984 Motorola"
        product5.productImage = "phone-fullscreen4"
        product5.cellImage = "club-bottle"
        
        product6.name = "1984 Motorola"
        product6.productImage = "phone-fullscreen4"
        product6.cellImage = "the-sub"
        
        product7.name = "1984 Motorola"
        product7.productImage = "phone-fullscreen4"
        product7.cellImage = "draughtkeg"
        
        products = [product1, product2, product3, product4, product5, product6, product7]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "ShowProduct"){
            let productVC:ProductViewController = segue.destinationViewController as! ProductViewController
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) else {
                return
            }
            productVC.product = products?[indexPath.row]
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let p = products{
            return p.count
        }
        return 0
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as UITableViewCell
        
        let product = products?[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColorFromRGB(0x004521)
        
        if let p = product{
            cell.textLabel?.text = p.name
            cell.textLabel?.textColor = UIColor.whiteColor()
            if let i = p.cellImage{
                cell.imageView?.image = UIImage(named: i)
                cell.selectedBackgroundView = backgroundView
                cell.imageView?.layer.masksToBounds = true;
                cell.imageView?.layer.cornerRadius = 25;
                cell.imageView?.layer.borderColor = UIColor.whiteColor().CGColor  // set cell border color here
                cell.imageView?.layer.borderWidth = 4 // set border width here
            }
        }
  
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
