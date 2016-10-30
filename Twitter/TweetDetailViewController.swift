//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Duc Dinh on 10/30/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
  
  var selectedTweet: Tweet!

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var numRetweetsLabel: UILabel!
  @IBOutlet weak var numFavoritesLabel: UILabel!
  
  
  func customNavigationBar() {
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.barTintColor = Colors.picton
      navigationBar.tintColor = UIColor.white
      self.title = "Tweet"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customNavigationBar()
    
    profileImageView.setImageWith(selectedTweet.user.profileImageUrl as URL)
    nameLabel.text = selectedTweet.user.name
    screennameLabel.text = selectedTweet.user.screenname
    tweetLabel.text = selectedTweet.text
    
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    timeLabel.text = formatter.string(from: selectedTweet.createdAt as Date)
    numRetweetsLabel.text = String(selectedTweet.numberOfRetweets)
    numFavoritesLabel.text = String(selectedTweet.numberOfFavorites)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
