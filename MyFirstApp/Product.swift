//
//  Product.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 14/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import Foundation
import FirebaseDatabase

@objc(Product)
class Product : NSObject, NSCoding {
    var key: String?
    var name: String?
    var productImage: String?
    var cellImage: String?
    var qty: Int?
    var ref: FIRDatabaseReference?
    
    override init() {
        self.key = ""
        self.name = ""
        self.productImage = ""
        self.cellImage = ""
        self.ref = nil
    }
    
    required init(coder aDecoder: NSCoder) {
        
        if let key = aDecoder.decodeObjectForKey("key") as? String {
            self.key = key
        }
        if let name = aDecoder.decodeObjectForKey("name") as? String {
            self.name = name
        }
        if let productImage = aDecoder.decodeObjectForKey("productImage") as? String {
            self.productImage = productImage
        }
        if let cellImage = aDecoder.decodeObjectForKey("cellImage") as? String {
            self.cellImage = cellImage
        }
        if let qty = aDecoder.decodeObjectForKey("qty") as? Int {
            self.qty = qty
        }
        if let ref = aDecoder.decodeObjectForKey("ref") as? FIRDatabaseReference {
            self.ref = ref
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let key = self.key {
            aCoder.encodeObject(key, forKey: "key")
        }
        if let name = self.name {
            aCoder.encodeObject(name, forKey: "name")
        }
        if let productImage = self.productImage {
            aCoder.encodeObject(productImage, forKey: "productImage")
        }
        if let cellImage = self.cellImage {
            aCoder.encodeObject(cellImage, forKey: "cellImage")
        }
        if let qty = self.qty {
            aCoder.encodeObject(qty, forKey: "qty")
        }
        if let ref = self.ref {
            aCoder.encodeObject(ref, forKey: "ref")
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as? String
        productImage = snapshotValue["productImage"] as? String
        cellImage = snapshotValue["cellImage"] as? String
        qty = snapshotValue["qty"] as? Int
        ref = snapshot.ref
    }
}
