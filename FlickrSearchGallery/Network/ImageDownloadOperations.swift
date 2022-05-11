//
//  ImageDownloadOperations.swift
//  FlickrSearchGallery
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import Foundation
import UIKit

protocol ImageOperations {
    
}
class ImageDownloader: Operation, ImageOperations {
    let flickrRecord: FlickrRecord
    
    init(_ flickrRecord: FlickrRecord) {
      self.flickrRecord = flickrRecord
    }
    
    override func main() {
      if isCancelled {
        return
      }
              
    guard let url = URL(string: flickrRecord.url) else {return}
        
      guard let imageData = try? Data(contentsOf:url) else { return }
      
      if isCancelled {
        return
      }
      
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
    
  lazy var downloadsInProgress: [IndexPath: ImageOperations] = [:]
    
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Download queue"
    queue.maxConcurrentOperationCount = 10
    return queue
  }()
}


