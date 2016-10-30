//
//  User.swift
//  Twitter
//
//  Created by Duc Dinh on 10/30/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
  
  var name: String
  var screenname: String
  var profileImageUrl: NSURL
  var tagline: String
  var dictionary: NSDictionary
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    
    self.name = dictionary["name"] as! String
    self.screenname = dictionary["screen_name"] as! String
    self.profileImageUrl = NSURL(string: (dictionary["profile_image_url"] as! String).replacingOccurrences(of: "_normal", with: "_bigger"))!
    self.tagline = dictionary["description"] as! String
  }
  
  func logout() {
    User.currentUser = nil
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
  }
  
  class var currentUser: User? {
    get {
      if _currentUser == nil {
        let data = UserDefaults.standard.object(forKey: currentUserKey) as? NSData
        if data != nil {
          do {
            let dictionary = try JSONSerialization.jsonObject(with: data! as Data, options: []) as? NSDictionary
            _currentUser = User(dictionary: dictionary!)
          } catch {
            print("Failed to parse json to data!")
          }
        }
      }
      return _currentUser
    }
    set(user) {
      _currentUser = user
      
      if _currentUser != nil {
        do {
          let data = try JSONSerialization.data(withJSONObject: user!.dictionary, options: [])
          UserDefaults.standard.set(data, forKey: currentUserKey)
        } catch {
          print("Failed to parse data to json!")
        }
      } else {
        UserDefaults.standard.set(nil, forKey: currentUserKey)
      }
      UserDefaults.standard.synchronize()
    }
  }
  
}

