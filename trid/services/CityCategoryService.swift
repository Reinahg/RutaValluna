//
//  CityCategoryService.swift
//  trid
//
//  Created by Black on 9/30/16.
//  Copyright © 2016 Black. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage

class CityCategoryService: NSObject {
    // ref
    var ref : DatabaseReference!
    let path = "category"
    var subpath = ""
    
    // data
    var cityCategories : [FCityCategory] = [] // link city vs category
    var categoriesOfCurrentCity : [FCategory] = []
    
    // Singleton
    static let shared = CityCategoryService();
    
    // init
    override init() {
        super.init()
    }
    
    public func configureDatabase(citykey: String, finish: @escaping () -> Void) { // _ block: @escaping () -> Void
        // remove old data
        self.cityCategories.removeAll()
        self.categoriesOfCurrentCity.removeAll()
        
        // ref
        ref = Database.database().reference().child(String(format:"category/%@", citykey))
        ref.keepSynced(true)
        // remove all observe
        ref.removeAllObservers()
        // added
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let cc = FCityCategory(path: self.subpath)
            self.cityCategories.append(cc)
        })
        // finished
        ref.observeSingleEvent(of: .value, with: {(snapshot) -> Void in
            // parse data
            for (index,_) in self.cityCategories.enumerated(){
                let cat = CategoryService.shared.categories[index]
                self.categoriesOfCurrentCity.append(cat)
                
            }
            debugPrint("DONE GET City-Category")
            // finish
            finish()
        })
    }
    
}
