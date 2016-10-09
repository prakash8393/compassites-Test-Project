//
//  CustomizeOptionTableViewCell.swift
//  CodingChallenge
//
//  Created by Madhan Prakash on 09/10/16.
//  Copyright © 2016 CompassitesInc. All rights reserved.
//

import UIKit

protocol CalculatePriceDeleGate {

    func canProceedSelectionWithIndex(index:Int,option:CustomizeOption) -> Bool
}

class CustomizeOptionTableViewCell: UITableViewCell {

    var priceDelegate:CalculatePriceDeleGate!
    @IBOutlet weak var optionNameLabel: UILabel!
    @IBOutlet weak var optionsCollectionView: UICollectionView! {
        
        didSet {
           optionsCollectionView.dataSource = self
            optionsCollectionView.delegate = self
            
        }
    }
    
    weak var option:CustomizeOption! {
        
        didSet{
            
            optionNameLabel.text = option.title
            self.optionsCollectionView.reloadData()
        }
    }
}


extension CustomizeOptionTableViewCell : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return option.options.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.option.view", forIndexPath: indexPath) as! ButtonCell
        cell.optionDelegate = self
        let image = UIImage(named: self.option.selectedIndex == indexPath.row ? "selected":"un_selected")
        cell.textButton.setBackgroundImage(image, forState: .Normal)
        cell.textButton.setTitle(option.options[indexPath.row], forState: .Normal)
        return cell
    }
}

extension CustomizeOptionTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let height =  CGRectGetHeight(collectionView.frame)
        return CGSizeMake(70 , height)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 5.0
    }
}

extension CustomizeOptionTableViewCell: TappedOnOptionDelegate {
    
    func tappedOnOption(option: String) {
        
        let currentSelection = self.option.options.indexOf(option)!
        let previousSelection = self.option.selectedIndex
        
        if self.priceDelegate.canProceedSelectionWithIndex(currentSelection, option: self.option) {
        
            if previousSelection == -1  || previousSelection == currentSelection {
                self.optionsCollectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: currentSelection, inSection: 0)])
            }else {
                
                let indexPaths = [
                    NSIndexPath(forRow: currentSelection, inSection: 0),
                    NSIndexPath(forRow: previousSelection, inSection: 0)
                ]
                
                print("removing from \(previousSelection) adding \(currentSelection)")
                print("CURRENT \(self.option.selectedIndex) ")
                self.optionsCollectionView.reloadItemsAtIndexPaths(indexPaths)
            }
        }
    }
}
