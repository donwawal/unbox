//
//  PhotoCell.swift
//  unbox
//
//  Created by Jules Walter on 6/13/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    var photo: UIImage!
    @IBOutlet weak var cellContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
