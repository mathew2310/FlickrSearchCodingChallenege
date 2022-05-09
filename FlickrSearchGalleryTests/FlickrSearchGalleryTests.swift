//
//  FlickrSearchGalleryTests.swift
//  FlickrSearchGalleryTests
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import XCTest
@testable import FlickrSearchGallery

class PhotoSearchGallaryTests: XCTestCase {
    
    var viewModel:FlickrSearchViewModel!
    var networkManager:MockNetworkManager!
    
    override func setUpWithError() throws {
        
        networkManager = MockNetworkManager()
        
        viewModel = FlickrSearchViewModel(networkManager: networkManager)
    }


    override func tearDownWithError() throws {
        viewModel = nil
    
    }

    func testSearchPhotos_success() {

        let request = Request(baseUrl: APIEndPoints.baseUrl, path:"", params: ["method":APIEndPoints.photoMethod, "text":"cat", "api_key": APIEndPoints.apiKey, "format" : "json", "nojsoncallback" : "1"])

        viewModel.search(request: request)
        
        XCTAssertEqual(viewModel.flickrDetailsCount, 100)

        XCTAssertEqual(viewModel.flickrDetails.first?.title, "cat rider")

    }
    
    func testSearchPhotos_failure() {

        let request = Request(baseUrl: APIEndPoints.baseUrl, path:"failedResonce", params: ["method":APIEndPoints.photoMethod, "text":"cat", "api_key": APIEndPoints.apiKey, "format" : "json", "nojsoncallback" : "1"])

        viewModel.search(request: request)

        XCTAssertEqual(viewModel.flickrDetailsCount, 0)

    }
    

}
