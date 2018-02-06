//
//  PostTableViewCell.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/4/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var thumbnailContainer: UIView!
    @IBOutlet weak var thumbnailProgress: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
