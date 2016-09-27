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
        self.navigationController?.isNavigationBarHidden = false
        
        let product1 = Product()
        let product2 = Product()
        let product3 = Product()
        let product4 = Product()
        let product5 = Product()
        let product6 = Product()
        let product7 = Product()
        
        product1.name = "DRAUGHT"
        product1.productImage = "fullscreen2"
        product1.cellImage = "draught"
        
        product2.name = "THE ICON"
        product2.productImage = "fullscreen1"
        product2.cellImage = "the-icon"
        
        product3.name = "THE CAN"
        product3.productImage = "fullscreen3"
        product3.cellImage = "the-can"
        
        product4.name = "EXTRA COLD"
        product4.productImage = "fullscreen4"
        product4.cellImage = "extra-cold"
        
        product5.name = "CLUB BOTTLE"
        product5.productImage = "fullscreen5"
        product5.cellImage = "club-bottle"
        
        product6.name = "THE SUB"
        product6.productImage = "fullscreen6"
        product6.cellImage = "the-sub"
        
        product7.name = "DRAUGTHKEG"
        product7.productImage = "fullscreen7"
        product7.cellImage = "draughtkeg"
        
        products = [product1, product2, product3, product4, product5, product6, product7]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "ShowProduct"){
            let productVC:ProductViewController = segue.destination as! ProductViewController
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
                return
            }
            productVC.product = products?[(indexPath as NSIndexPath).row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let p = products{
            return p.count
        }
        return 0
    }
    
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as UITableViewCell
        
        let product = products?[(indexPath as NSIndexPath).row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColorFromRGB(0x004521)
        
        if let p = product{
            cell.textLabel?.text = p.name
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont(name: "Heineken", size: 20)
            if let i = p.cellImage{
                cell.imageView?.image = UIImage(named: i)
                cell.selectedBackgroundView = backgroundView
                cell.imageView?.layer.masksToBounds = true;
                cell.imageView?.layer.cornerRadius = 25;
                cell.imageView?.layer.borderColor = UIColor.white.cgColor  // set cell border color here
                cell.imageView?.layer.borderWidth = 4 // set border width here
            }
        }
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
