//
//  FlickrSearchViewModel.swift
//  FlickrSearchGallery
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import Foundation
import Combine


import Combine


protocol FlickrSearchViewModelType {
    var stateBinding: Published<ViewState>.Publisher { get }
    var flickrDetailsCount:Int { get }
    var flickrDetails:[FlickrDetail] { get }
    var flickrRecords:[FlickrRecord] { get }

    func search(request: Request)
}

final class FlickrSearchViewModel: FlickrSearchViewModelType {
    
    var stateBinding: Published<ViewState>.Publisher{ $state }
    
    private let networkManager:Networking
    private var cancellables:Set<AnyCancellable> = Set()
    
    @Published  var state: ViewState = .none
    
    var flickrDetails:[FlickrDetail] = []
    var flickrRecords:[FlickrRecord] = []
    

    var flickrDetailsCount: Int {
        return flickrDetails.count
    }
    
    init(networkManager:Networking) {
        self.networkManager = networkManager
    }
    
    func search(request: Request) {
        
        state = ViewState.loading
        let publisher = networkManager.doApiCall(apiRequest: request)
        
        let cancalable = publisher.sink { [weak self ]completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self?.flickrDetails = []
                self?.state = ViewState.error("Network Not Availale")
            }
        } receiveValue: { [weak self] images in
            self?.flickrDetails = images
            self?.flickrRecords =  images.map {
                FlickrRecord(name: $0.title, url: $0.url)
            }
            self?.state = ViewState.finishedLoading
        }
        self.cancellables.insert(cancalable)
    }
    
    
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
}
