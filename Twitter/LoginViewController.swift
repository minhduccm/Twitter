//
//  LoginViewController.swift
//  Twitter
//
//  Created by Duc Dinh on 10/28/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  @IBAction func loginButtonTap(_ sender: AnyObject) {
    
    TwitterClient.sharedInstance.loginWithCompletion() {
      (user: User?, error: NSError?) in
      if user != nil {
        self.performSegue(withIdentifier: "entrySegue", sender: self)
      } else {
        // Handle login error
        print("Failed to login!")
      }
    }
  }
  
  

}
