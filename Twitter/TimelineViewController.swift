//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Duc Dinh on 10/30/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit
import MBProgressHUD

class TimelineViewController: UIViewController {

  @IBOutlet weak var timelineTableView: UITableView!
  
  var tweets: [Tweet]?
  lazy var refreshCtl = UIRefreshControl()
  
  func customNavigationBar() {
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.barTintColor = Colors.picton
      navigationBar.tintColor = UIColor.white
      let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
      navigationBar.titleTextAttributes = titleDict as? [String : Any]
    }
  }
  
  func initPullToRefresh() {
    refreshCtl.addTarget(self, action: #selector(TimelineViewController.loadTweets), for: UIControlEvents.valueChanged)
    timelineTableView.insertSubview(refreshCtl, at: 0)
  }
  
  func loadTweets() {
    MBProgressHUD.showAdded(to: self.view, animated: true)
    TwitterClient.sharedInstance.homeTimelineWithParams(params: nil, completion: { (tweets, error) -> () in
      
      MBProgressHUD.hide(for: self.view, animated: true)
      self.tweets = tweets
      self.timelineTableView.reloadData()
      self.refreshCtl.endRefreshing()
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "StatusPosted"), object: nil, queue: nil) { (notification: Notification!) -> Void in
      let tweet = notification.object as! Tweet
      self.tweets?.insert(tweet, at: 0)
      self.timelineTableView.reloadData()
    }
    
    timelineTableView.dataSource = self
    timelineTableView.delegate = self
    timelineTableView.rowHeight = UITableViewAutomaticDimension
    timelineTableView.estimatedRowHeight = 120
    initPullToRefresh()
    customNavigationBar()
    loadTweets()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    if let row = timelineTableView.indexPathForSelectedRow {
      timelineTableView.deselectRow(at: row, animated: false)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tweetDetail" {
      let tweetDetailViewController = segue.destination as! TweetDetailViewController
      let selectedIdx = timelineTableView.indexPathForSelectedRow?.row
      tweetDetailViewController.selectedTweet = tweets?[selectedIdx!]
    }
  }
}

extension TimelineViewController : UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = timelineTableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TImelineTableViewCell
    cell.tweet = tweets?[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
  }
}

extension TimelineViewController : UITableViewDelegate {
  
}
