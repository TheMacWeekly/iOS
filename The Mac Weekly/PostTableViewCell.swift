//
//  PostTableViewCell.swift
//  The Mac Weekly
//
//  Created by Library Checkout User on 2/4/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {
    
    
    
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var previewImageContainer: UIView!
    
    func loadPost(_ post: Post, shouldUseLargeImage: Bool = false) {
        let formatter = DateFormatter()
        formatter.dateFormat = defaultDateFormat
        dateLabel.text = formatter.string(from: post.time)
        if let authorName = post.author?.name {
            authorNameLabel.text = "By \(authorName)"
            authorNameLabel.isHidden = false
        } else {
            authorNameLabel.isHidden = true
        }
        titleLabel.text = post.title
        previewImageContainer.isHidden = false
        
        if shouldUseLargeImage {
            post.displayImage(completion: { self.setPreviewImage(img: $0) } )
        } else {
            post.thumbnail(completion: { self.setPreviewImage(img: $0) } )
        }
        
        titleLabel.isEnabled = true
    }
    
    func setPreviewImage(img: Image?) {
        if let img = img {
            self.previewImage.image = img
            self.previewImage.layer.cornerRadius = 8
            self.previewImageContainer.isHidden = false
        } else {
            self.previewImageContainer.isHidden = true
        }
    }
    
    func loadErrorPost() {
        titleLabel.text = "Error: Could not fetch post"
        titleLabel.isEnabled = false
        dateLabel.text = nil
        authorNameLabel.text = nil
        previewImageContainer.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
