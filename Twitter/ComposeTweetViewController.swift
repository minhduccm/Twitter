//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Duc Dinh on 10/30/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var tweetTextView: UITextView!
  
  func customNavigationBar() {
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.barTintColor = Colors.picton
      navigationBar.tintColor = UIColor.white
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    customNavigationBar()
    
    profileImageView.setImageWith(User.currentUser?.profileImageUrl as! URL)
    profileImageView.layer.cornerRadius = 9.0
    profileImageView.layer.masksToBounds = true
    nameLabel.text = User.currentUser?.name
    screennameLabel.text = "@\(User.currentUser!.screenname)"
    tweetTextView.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func cancelButtonTap(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func tweetButtonTap(_ sender: AnyObject) {
    let tweet = tweetTextView.text
    if (tweet == "") {
      return
    }
    
    let params: NSDictionary = [
      "status": tweet
    ]
    
    TwitterClient.sharedInstance.postStatusUpdateWithParams(params: params, completion: { (status, error) -> () in
      if error != nil {
        NSLog("error posting status: \(error)")
        self.dismiss(animated: true, completion: nil)
        return
      }
      //NSNotificationCenter.defaultCenter().postNotificationName(TwitterEvents.StatusPosted, object: status)
      self.dismiss(animated: true, completion: nil)
    })
  }

}
