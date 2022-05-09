//
//  MockNetworkManager.swift
//  FlickrSearchGalleryTests
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import Foundation
@testable import FlickrSearchGallery
import Combine

class MockNetworkManager: Networking {
    func doApiCall(apiRequest: Requestable) -> Future<[FlickrDetail], NetworkError> {

        return Future { promise in
            
            let bundle = Bundle(for:MockNetworkManager.self)
            
            guard let url = bundle.url(forResource:apiRequest.path, withExtension:"json"),
                  let data = try? Data(contentsOf: url)

            else {
                promise(.failure(NetworkError.dataNotFound))
          
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(FlickrSearchResponce.self, from: data) else {
                return promise(.failure(NetworkError.parsingError))
            }
            
           let flickrDetails = decodedResponse.photos.photo.map {
               FlickrDetail( title: $0.title, url: "\(APIEndPoints.imagesBaseUrl)/\($0.server)/\($0.id)_\($0.secret)_w.jpg")
            }
        
            return promise(.success(flickrDetails))
        }
    }
}
