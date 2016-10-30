//
//  File.swift
//  Twitter
//
//  Created by Duc Dinh on 10/30/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  var user: User
  var text: String
  var createdAt: NSDate
  var numberOfRetweets: Int
  var numberOfFavorites: Int
  
  init(dictionary: NSDictionary) {
    self.user = User(dictionary: dictionary["user"] as! NSDictionary)
    self.text = dictionary["text"] as! String
    
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    self.createdAt = formatter.date(from: dictionary["created_at"] as! String)! as NSDate
    
    self.numberOfRetweets = dictionary["retweet_count"] as! Int
    self.numberOfFavorites = dictionary["favorite_count"] as! Int
  }
  
  class func statusesWithArray(array: [NSDictionary]) -> [Tweet] {
    var statuses = [Tweet]()
    for dictionary in array {
      statuses.append(Tweet(dictionary: dictionary))
    }
    return statuses
  }
}

