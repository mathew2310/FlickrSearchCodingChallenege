//
//  FlickrSearchGalleryTests.swift
//  FlickrSearchGalleryTests
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import XCTest
import Combine

@testable import FlickrSearchGallery

class PhotoSearchGallaryTests: XCTestCase {
    
    var viewModel:FlickrSearchViewModel!
    var networkManager:MockNetworkManager!
    private var bindings = Set<AnyCancellable>()

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
    

    func testStartImageDownload() {
        
        let expected = expectation(description: "callback happened")

        let indexpath = IndexPath(row: 0, section: 0)
        viewModel.startDownload(imageDownloader:MockImageDownLoader(), at: indexpath)
        
        let cancellable =  viewModel.$state.dropFirst().sink { states in
            expected.fulfill()

        }
        
        self.bindings.insert(cancellable)

        wait(for: [expected], timeout: 3)

        XCTAssertEqual(viewModel.state, .refresh([indexpath]))
    }
}
