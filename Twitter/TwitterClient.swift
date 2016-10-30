//
//  TwitterClient.swift
//  Twitter
//
//  Created by Duc Dinh on 10/28/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager


let twitterConsumerKey = "zpGyK4vO6wOeLwsRxPbIfflFK"
let twitterConsumerSecret = "dgiboA2FPydhknfgAGUo7wTfZveTaxcZUAFqlCUxAhEXqvCvwJ"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
  
  var loginCompletion: ((_ user: User?, _ error: NSError?) -> ())?
  
  class var sharedInstance: TwitterClient {
    struct Static {
      static let instance = TwitterClient(baseURL: twitterBaseURL as URL!, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    }
    return Static.instance!
  }
  
  func homeTimelineWithParams(params: NSDictionary?, completion: @escaping (_ statuses: [Tweet]?, _ error: NSError?) -> ()) {
    self.get("1.1/statuses/home_timeline.json",
      parameters: nil,
      success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
        let tweets = Tweet.statusesWithArray(array: response as! [NSDictionary])
        completion(tweets, nil)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
        print("error getting home timeline")
        completion(nil, error as NSError?)
      }
    )
  }
  
  func postStatusUpdateWithParams(params: NSDictionary?, completion: @escaping (_ status: Tweet?, _ error: NSError?) -> ()) {
    
    
    
    TwitterClient.sharedInstance.post("1.1/statuses/update.json",
      parameters: params,
      success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
        let status = Tweet(dictionary: response as! NSDictionary)
        completion(status, nil)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
        print("error posting status update")
        completion(nil, error as NSError?)
      }
    )
  }
  
  func loginWithCompletion(completion: @escaping (_ user: User?, _ error: NSError?) -> ()) {
    self.loginCompletion = completion
    
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    
    TwitterClient.sharedInstance.fetchRequestToken(
      withPath: "oauth/request_token",
      method: "GET",
      callbackURL: NSURL(string: "cs3-twitter-client://oauth") as URL!,
      scope: nil,
      success: { (requestToken: BDBOAuth1Credential?) -> Void in
        let url = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)";
        let authURL = NSURL(string: url)
        UIApplication.shared.open(authURL as! URL, options: [:], completionHandler: nil)
      },
      failure: {
        (error: Error?) -> Void in
        print("Failed to get request token")
        self.loginCompletion?(nil, error as NSError?)
      }
    )
  }
  
  func openURL(url: NSURL) {
    
    self.fetchAccessToken(
      withPath: "oauth/access_token",
      method: "POST",
      requestToken: BDBOAuth1Credential(queryString: url.query),
      success: { (accessToken: BDBOAuth1Credential?) -> Void in
        
        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
        TwitterClient.sharedInstance.get(
          "1.1/account/verify_credentials.json",
          parameters: nil,
          success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            User.currentUser = user
            print("user: \(user.name)")
            self.loginCompletion?(user, nil)
          },
          failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
            print("error getting current user")
            self.loginCompletion?(nil, error as NSError?)
        })
      },
      failure: { (error: Error?) -> Void in
        print("Failed to receive access token")
        self.loginCompletion?(nil, error as NSError?)
      }
    )
  }
  
}
