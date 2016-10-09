//
//  ProductDetail.swift
//  CodingChallenge
//
//  Created by Madhan Prakash on 09/10/16.
//  Copyright © 2016 CompassitesInc. All rights reserved.
//

import Foundation

class ProductDetail: NSObject {
    
    let assetURLs : [String]
    let title: String
    let productDescription:String
    let customizeOptions:[CustomizeOption]
    let variants:[Variant]
    
    init(assets:[String],title:String,
         productDescription:String,
         options:[CustomizeOption],variant:[Variant]) {
        
        self.assetURLs = assets
        self.title  = title
        self.productDescription = productDescription
        self.customizeOptions = options
        self.variants = variant
    }
}

class CustomizeOption : NSObject {
    
    let options:[String]
    let title:String
    var selectedIndex : Int = -1
    
    init(title:String,options:[String]) {
        self.options = options
        self.title = title
    }
    
    func selectedOption()-> String! {
        if selectedIndex == -1 {
            return nil
        }else {
            return self.options[selectedIndex]
        }
    }
}

class  Variant: NSObject {
    
    let size :String
    let price :String
    let metalColor : String
    let metalPurity : String
    let diamondQuality : String
    
    init(size:String,price:String,color:String,purity:String,quality:String) {
        
        self.size = size
        self.price = price
        self.metalColor = color
        self.metalPurity = purity
        self.diamondQuality = quality
    }
}


extension ProductDetail {
    
    class func fetchProductDetails(completion:(ProductDetail!,Bool)->()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("product_detail", ofType: "json")!)
            
            do {
                let json = try  NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                if let detail = json["productdetail"]  {
                    
                    var assets = [String]()
                    for asset in detail!["assets"] as!  Array<Dictionary<String,AnyObject>> {
                        assets.append(asset["imgUri"]! as! String)
                    }
                    
                    let diamondQualities = CustomizeOption(title: "Diamond:",
                                                           options: detail!["Customizations"]!!["DiamondQuality"] as! [String])
                    
                    let colors = CustomizeOption(title: "Metal Color",
                                                 options: detail!["Customizations"]!!["MetalColors"] as! [String])
                    
                    let sizes = CustomizeOption(title: "Rings:", options: detail!["Customizations"]!!["sizes"] as! [String])
                    let carat = CustomizeOption(title: "Carat:",options: ["14","18"
                        ])
                    
                    var variants = [Variant]()
                    for variant in detail!["Variants"] as!  Array<Dictionary<String,AnyObject>> {
                        
                        let size = variant["size"] as! String
                        let price = variant["totalPrice"] as! String
                        let color = variant["selectedCustomization"]!["metalColor"] as! String
                        let purity = variant["selectedCustomization"]!["metalPurity"] as! String
                        let quality = variant["selectedCustomization"]!["diamondQuality"] as! String
                        
                        let theVariant = Variant(size: size, price: price, color: color, purity: purity, quality: quality)
                        variants.append(theVariant)
                        
                    }
                    
                    let productDetail = ProductDetail(assets: assets,
                                                      title: detail!["title"] as! String,
                                                      productDescription: detail!["shortDesc"] as! String,
                                                      options:[carat,diamondQualities,colors,sizes],
                                                      variant:variants)
                    // main queue
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(productDetail,true)
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
