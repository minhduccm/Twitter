//
//  NSDate.swift
//  Twitter
//
//  Created by Duc Dinh on 10/30/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import Foundation
import SwiftMoment

extension NSDate {
  func timeAgo() -> String {
    let mm = moment(self as Date)
    let diff = moment().intervalSince(mm)
    
    if (diff.days > 1) {
      return mm.format("MM/dd/yyyy")
      
    } else if (diff.hours >= 1) {
      return String(format: "%dh", arguments: [Int(diff.hours)])
      
    } else if (diff.minutes >= 1) {
      return String(format: "%dm", arguments: [Int(diff.minutes)])
      
    } else {
      return String(format: "%ds", arguments: [Int(diff.seconds)])
    }
  }
}
