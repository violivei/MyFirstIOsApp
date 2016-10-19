//
//  ApplicationProperties.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 18/10/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import Foundation

class ApplicationProperties {
    var defaultProduct: Product?
    let userDefaults = NSUserDefaults.standardUserDefaults()
    static let sharedInstance = ApplicationProperties()
}
