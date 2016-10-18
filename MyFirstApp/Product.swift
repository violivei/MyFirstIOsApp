//
//  Product.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 14/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Product {
    var key: String?
    var name: String?
    var productImage: String?
    var cellImage: String?
    var qty: Int?
    let ref: FIRDatabaseReference?
    
    init() {
        self.key = ""
        self.name = ""
        self.productImage = ""
        self.cellImage = ""
        self.ref = nil
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
