//
//  ProductListViewController.swift
//  CodingChallenge
//
//  Created by Madhan Prakash on 08/10/16.
//  Copyright © 2016 CompassitesInc. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var products : [Product]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Products"
        collectionView.dataSource = self
        collectionView.delegate = self
        
        Product.fetchProducts { (products, success) in
            
            if success {
                self.products = products
                self.collectionView.reloadData()
            }else {
                // Display Aert with err
            }
        }
    }
}

extension ProductListViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  let products = products {
            return products.count
        }
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.code", forIndexPath: indexPath) as! ProductViewCell
        cell.product  = products[indexPath.row]
        return cell
    }
}

extension ProductListViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width =  (CGRectGetWidth(collectionView.frame) / 2 ) - 5
        return CGSizeMake(width , width)
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 5.0
    }
}

extension ProductListViewController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("com.detail")
        navigationController?.pushViewController(detailVC!, animated: true)
    }
}
