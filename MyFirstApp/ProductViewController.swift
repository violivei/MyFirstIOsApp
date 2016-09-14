//
//  ProductViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 13/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    var productName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productNameLabel.text = productName
        productImageView.image = UIImage(named: "phone-fullscreen3")
    }
 
    @IBAction func addToCartPressed(sender: AnyObject) {
        print("Button Pressed")
    }

}
