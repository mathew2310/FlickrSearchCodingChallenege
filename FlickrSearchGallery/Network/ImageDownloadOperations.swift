//
//  ImageDownloadOperations.swift
//  FlickrSearchGallery
//
//  Created by Mathew Ijidakinro on 09/05/2022.
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

class ImageDownloader: Operation {
    //1
    let flickrRecord: FlickrRecord
    
    //2
    init(_ flickrRecord: FlickrRecord) {
      self.flickrRecord = flickrRecord
    }
    
    //3
    override func main() {
      //4
      if isCancelled {
        return
      }
      
      //5
        
    guard let url = URL(string: flickrRecord.url) else {return}
        
      guard let imageData = try? Data(contentsOf:url) else { return }
      
      //6
      if isCancelled {
        return
      }
      
      //7
      if !imageData.isEmpty {
        flickrRecord.image = UIImage(data:imageData)
        flickrRecord.state = .downloaded
      } else {
        flickrRecord.state = .failed
        flickrRecord.image = UIImage(named: "Failed")
      }
    }
  }


class PendingOperations {
    
  lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
}
