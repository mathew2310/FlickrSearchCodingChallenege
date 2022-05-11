//
//  ViewController.swift
//  FlickrSearchGallery
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import UIKit
import Combine

class FlickrSearchViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var bindings = Set<AnyCancellable>()
        
    private let viewModel:FlickrSearchViewModelType = FlickrSearchViewModel(networkManager: NetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        bindViewModelState()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text{
          let request = Request(baseUrl: APIEndPoints.baseUrl, path:"", params: ["method":APIEndPoints.photoMethod, "text":"\(text)", "api_key": APIEndPoints.apiKey, "format" : "json", "nojsoncallback" : "1"])

            self.viewModel.search(request:request)
        }
    }

    private func bindViewModelState() {
        let cancellable =  viewModel.stateBinding.sink { completion in
            
        } receiveValue: { [weak self] launchState in
            DispatchQueue.main.async {
                self?.updateUI(state: launchState)
            }
        }
        self.bindings.insert(cancellable)
    }
    private func updateUI(state:ViewState) {
        switch state {
        case .none:
            collectionView.isHidden = true
        case .loading:
            collectionView.isHidden = true
            activityIndicator.startAnimating()
        case .finishedLoading:
            collectionView.isHidden = false
            activityIndicator.stopAnimating()
            collectionView.reloadData()
        case .error(let error):
            activityIndicator.stopAnimating()
            collectionView.reloadData()
            self.showAlert(message:error)


        case .refresh(let indexpaths):
            self.collectionView.reloadItems(at: indexpaths)

        }
    }

}

extension FlickrSearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.flickrDetailsCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? FlickrSearchCollectionViewCell else {return UICollectionViewCell()}
    
        let flickrDetail = viewModel.flickrRecords[indexPath.row]

        switch (flickrDetail.state) {
       
        case .failed:
            collectionCell.imgDesc?.text = "Failed to load"
        case .new :
            
            viewModel.startDownload(imageDownloader: ImageDownloader(flickrDetail), at: indexPath)
          
        case .downloaded :
            collectionCell.flickImage.image = flickrDetail.image
        }
        
        return collectionCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}


extension FlickrSearchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 4 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:100)
    }
}

