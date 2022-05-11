//
//  FlickrRecord.swift
//  FlickrSearchGallery
//
//  Created by MAC on 11/05/22.
//

import Foundation
import UIKit

enum FlickrRecordState {
  case new, downloaded, failed
}

class FlickrRecord {
  let name: String
  let url: String
  var state = FlickrRecordState.new
  var image = UIImage(named: "Placeholder")
  
  init(name:String, url:String) {
    self.name = name
    self.url = url
  }
}
