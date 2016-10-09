//
//  CustomizeProductViewController.swift
//  CodingChallenge
//
//  Created by Madhan Prakash on 09/10/16.
//  Copyright © 2016 CompassitesInc. All rights reserved.
//

import UIKit

class CustomizeProductViewController: UIViewController {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var customizeOptionsTableView: UITableView!
    
    weak var detail:ProductDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeOptionsTableView.dataSource = self
        
        for option in detail.customizeOptions {
            option.selectedIndex = -1
        }
    }
}

extension UIViewController {
    
    func onMain(block: () -> ()) {
        if NSThread.isMainThread() {
            block()
        } else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
    
    func showAlert(message: String, withTitle title: String = "") {
        onMain { [weak self] in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

extension CustomizeProductViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detail == detail {
            return detail.customizeOptions.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("com.table.option") as! CustomizeOptionTableViewCell
        cell.priceDelegate = self
        cell.option = detail.customizeOptions[indexPath.row]
        return cell
    }
}

extension CustomizeProductViewController :  CalculatePriceDeleGate {
    
    func canProceedSelectionWithIndex(index: Int, option: CustomizeOption) -> Bool {
        
        let previousIndex = option.selectedIndex
        option.selectedIndex = index
        for customize in detail.customizeOptions {
            if customize != option && customize.selectedIndex == -1 {
                // rest are not selected  hence proceed
                return true
            }
        }

        let caratOption = detail.customizeOptions[0]
        let qualityOption = detail.customizeOptions[1]
        let colorOption = detail.customizeOptions[2]
        let sizeOption = detail.customizeOptions[3]
        
        let currentOption = detail.variants.filter({ variant  in
            
            if variant.size == sizeOption.selectedOption() &&
               variant.diamondQuality == qualityOption.selectedOption() &&
                variant.metalColor == colorOption.selectedOption() &&
                variant.metalPurity == caratOption.selectedOption() {
                
                return true
            }else {
                return false
            }
        })
        
        if currentOption.count > 0 {
            print("variant found")
            totalPriceLabel.text = "\(currentOption.first!.price)"
            return true
        }
        option.selectedIndex = previousIndex
        showAlert("No variants found")
        return false
    }
}
