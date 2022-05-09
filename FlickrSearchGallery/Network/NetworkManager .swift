//
//  NetworkManager .swift
//  FlickrSearchGallery
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import Foundation
import Combine

protocol Networking {
    func doApiCall(apiRequest:Requestable)-> Future<[FlickrDetail], ServiceError>
}

class NetworkManager: Networking {
    let session:URLSession
    init(session:URLSession = URLSession.shared) {
        self.session = session
    }
    
    func doApiCall(apiRequest: Requestable) -> Future<[FlickrDetail], ServiceError> {
        return Future { [weak self] promise in
            guard let request = URLRequest.getURLRequest(for: apiRequest) else {
                promise(.failure(ServiceError.failedToCreateRequest))
                return
            }
            self?.session.dataTask(with: request, completionHandler: { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    return promise(.failure(ServiceError.dataNotFound))
                }
                guard let _data = data, error == nil else {
                    return promise(.failure(ServiceError.dataNotFound))
                }
             
                guard let decodedResponse = try? JSONDecoder().decode(FlickrSearchResonce.self, from: _data) else {
                    return promise(.failure(ServiceError.parsingError))
                }
                
               let phototsDetails = decodedResponse.photos.photo.map {
                   FlickrDetail( title: $0.title, url: "\(APIEndPoints.imagesBaseUrl)/\($0.server)/\($0.id)_\($0.secret)_w.jpg")
                }
            
                return promise(.success(phototsDetails))
            }).resume()
        }
    }
}

extension URLRequest {
    static func getURLRequest(for apiRequest:Requestable)-> URLRequest? {
        if let url = URL(string:apiRequest.baseUrl.appending(apiRequest.path)),
           var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false){
            let queryItems = apiRequest.params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            urlComponents.queryItems = queryItems
            let urlRequest = URLRequest(url: urlComponents.url!)
            return urlRequest
        } else {
            return nil
        }
    }
}
