//
//  ViewState.swift
//  FlickrSearchGallery
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import Foundation

enum ViewState: Equatable {
    case none
    case loading
    case finishedLoading
    case error(String)
}
