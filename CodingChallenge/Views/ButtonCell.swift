//
//  ButtonCell.swift
//  CodingChallenge
//
//  Created by Madhan Prakash on 09/10/16.
//  Copyright © 2016 CompassitesInc. All rights reserved.
//

import UIKit

protocol TappedOnOptionDelegate {
    
    func tappedOnOption(option:String)
}

class ButtonCell: UICollectionViewCell {

    @IBOutlet weak var textButton: UIButton!
    var optionDelegate:TappedOnOptionDelegate?
    
    @IBAction func tappedOnOption(sender: AnyObject) {
        optionDelegate?.tappedOnOption((textButton.titleLabel?.text)!)
    }
    
}
