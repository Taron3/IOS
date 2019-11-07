//
//  NoteCellTableViewCell.swift
//  Notes
//
//  Created by 3 on 11/7/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class NoteCellTableViewCell: UITableViewCell {
    static var identifier = "NoteCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.isEnabled = false
    }

}
