//
//  FlickrSearchCollectionViewCell.swift
//  FlickrSearchGallery
//
//  Created by Mathew Ijidakinro on 09/05/2022.
//

import UIKit

class FlickrSearchCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var flickImage: UIImageView!
    @IBOutlet weak var imgDesc: UILabel!
    
    override func prepareForReuse() {
        self.flickImage.image = nil
    }
    
    func setData(_ flickrDetail: FlickrDetail) {
       // imgDesc.text = flickrDetail.title
//        let url = URL(string: photoDetail.url)
//        flickImage.kf.setImage(with:url)
    }
}
