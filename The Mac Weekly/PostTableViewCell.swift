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
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var thumbnailContainer: UIView!
    
    func loadPost(_ post: Post) {
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
        thumbnailContainer.isHidden = false
        post.thumbnail { thumbnail in
            if let thumbnail = thumbnail {
                self.thumbnailView.image = thumbnail
                self.thumbnailView.layer.cornerRadius = 8
                self.thumbnailContainer.isHidden = false
            } else {
                self.thumbnailContainer.isHidden = true
            }
        }
        titleLabel.isEnabled = true
    }
    
    func loadErrorPost() {
        titleLabel.text = "Error: Could not fetch post"
        titleLabel.isEnabled = false
        dateLabel.text = nil
        authorNameLabel.text = nil
        thumbnailContainer.isHidden = true
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
