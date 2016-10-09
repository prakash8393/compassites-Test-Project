//
//  Product.swift
//  CodingChallenge
//
//  Created by Madhan Prakash on 08/10/16.
//  Copyright © 2016 CompassitesInc. All rights reserved.
//

import Foundation

class Product : NSObject {

    let  productId :String
    let  productCode :String
    let  title :String
    let  price :NSNumber
    let  url :String
    
    init (productId:String,productCode:String,title:String,price:NSNumber,url:String) {
        self.productId = productId
        self.productCode = productCode
        self.title = title
        self.price = price
        self.url = url
    }
    
}

extension Product {
    
    class func fetchProducts(completion:([Product]!,Bool)->()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
         
            let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("product_list", ofType: "json")!)
            do {
                let json = try  NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let products = json["products"]  {
                    
                    var parsedProducts = [Product]()
                    for product in products as! Array<Dictionary<String,AnyObject>> {
                        
                        let parsedProduct = Product(productId: product["product_id"] as! String,
                                                    productCode: product["product_code"] as! String,
                                                    title: product["title"] as! String,
                                                    price: product["price"] as! NSNumber,
                                                    url: product["url"] as! String)
                        parsedProducts.append(parsedProduct)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(parsedProducts,true)
                    })
                }
                
            }catch {
                dispatch_async(dispatch_get_main_queue(), {
                    completion(nil,false)
                })
            }
        }

    }
}
