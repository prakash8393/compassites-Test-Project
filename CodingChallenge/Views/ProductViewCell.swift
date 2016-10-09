//
//  ProductViewCell.swift
//  CodingChallenge
//
//  Created by Madhan Prakash on 09/10/16.
//  Copyright © 2016 CompassitesInc. All rights reserved.
//

import UIKit
import Haneke

class ProductViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var product : Product! {
        didSet {
            titleLabel.text = product.title
            productImageView.hnk_setImageFromURL(NSURL(string: product.url)!)
        }
    }
    
}
