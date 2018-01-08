//
//  GalleryViewCell.swift
//  ImageGallery
//
//  Created by Khen Cruzat on 06/01/2018.
//  Copyright © 2018 Khen Cruzat. All rights reserved.
//

import UIKit

class GalleryViewCell: UITableViewCell, UITextFieldDelegate {
        
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }
    
    @objc func doubleTapped() {
        
        if let textField = subviews[1].subviews.first as? UITextField {
            if let tableView = superview as? UITableView {
                if tableView.indexPath(for: self)?.section == 0 {
                    textField.isEnabled = true
                    textField.becomeFirstResponder()
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
