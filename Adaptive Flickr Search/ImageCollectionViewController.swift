//
//  ImageCollectionViewController.swift
//  Adaptive Flickr Search
//
//  Created by Errol Cheong on 2018-01-22.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
}

class ImageCollectionViewController: UICollectionViewController {

    let networkManager = NetworkManager()
    var tag: String? {
        didSet {
            if let tag = tag {
                networkManager.queryImages(with: tag, completionHandler: { (jsonData) in
                    if let photos = jsonData["photo"] as? [[String: AnyObject]] {
                        self.flickrImages = photos.map{Photo.init(data: $0)}
                    }
                })
            }
        }
    }
    var flickrImages = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return flickrImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        if let cell = cell as? ImageCell {
            let imageData = flickrImages[indexPath.row]
            cell.titleLabel.text = imageData.title
            DispatchQueue.global(qos: .background).async {
                if let url = imageData.url, let image = try? UIImage(data: Data(contentsOf: url)) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }

        // Configure the cell
        return cell
    }

}

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}
