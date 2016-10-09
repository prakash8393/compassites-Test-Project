//
//  ProductViewController.swift
//  CodingChallenge
//
//  Created by Madhan Prakash on 09/10/16.
//  Copyright © 2016 CompassitesInc. All rights reserved.
//

import UIKit
import ImageSlideshow


class ProductViewController: UIViewController {
    
    
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var detail:ProductDetail! {
        
        didSet {
            
            let imageSource = detail.assetURLs.map({
                
                return SDWebImageSource(url: NSURL(string:$0)!)
            })
            imageSlideShow.setImageInputs(imageSource)
            self.title = "Listing Detail"
            self.titleLabel.text  = detail.title
            self.descriptionLabel.text = detail.productDescription
        }
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        ProductDetail.fetchProductDetails { (detail, success) in
            if success {
                self.detail = detail
            }else {
                // Show err
            }
        }
    }
    
    @IBAction func tappedOnCustomize(sender: AnyObject) {
     
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("CustomizeProductViewController") as! CustomizeProductViewController
        viewController.detail = self.detail
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
