//
//  TImelineTableViewCell.swift
//  Twitter
//
//  Created by Duc Dinh on 10/28/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class TImelineTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var statusTextLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  var tweet: Tweet? {
    willSet(newValue) {
      self.profileImage.setImageWith(newValue?.user.profileImageUrl as! URL)
      self.nameLabel.text = newValue?.user.name
      self.screennameLabel.text = "@\(newValue!.user.screenname)"
      self.statusTextLabel.text = newValue?.text
      self.timeLabel.text = newValue?.createdAt.timeAgo()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    profileImage.layer.cornerRadius = 9.0
    profileImage.layer.masksToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    
  }

}
