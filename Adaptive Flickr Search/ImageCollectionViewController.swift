//
//  ImageCollectionViewController.swift
//  Adaptive Flickr Search
//
//  Created by Errol Cheong on 2018-01-22.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var photo: Photo?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = ""
    }
    
}

class ImageCollectionViewController: UICollectionViewController {
    
    let networkManager = NetworkManager()
    var tag: String? {
        didSet {
            if let tag = tag {
                networkManager.queryImages(with: tag, completionHandler: { (jsonData) in
                    if let photos = jsonData["photo"] as? [[String: AnyObject]] {
                        self.flickrPhotos = photos.map{Photo.init(data: $0)}
                    }
                })
            }
        }
    }
    var flickrPhotos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return flickrPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        if let cell = cell as? ImageCell {
            let photo = flickrPhotos[indexPath.row]
            cell.titleLabel.text = photo.title
            cell.photo = photo
            DispatchQueue.global(qos: .background).async {
                if let url = photo.url, let image = try? UIImage(data: Data(contentsOf: url)) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        // Configure the cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ImageDetailViewController,
            let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first,
            let cell = collectionView?.cellForItem(at: selectedIndexPath) as? ImageCell {
            dvc.photo = cell.photo
            dvc.flickrImage = cell.imageView.image
        }
    }
}

class ImageDetailViewController: UIViewController {
    
    var photo: Photo?
    var flickrImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    
    var useAccessibilityConstraints = false {
        didSet {
            if useAccessibilityConstraints || traitCollection.horizontalSizeClass == .compact {
                stackView.axis = .vertical
            } else {
                stackView.axis = .horizontal
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.image = flickrImage
        titleLabel.text = photo?.title
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillLayoutSubviews() {
        useAccessibilityConstraints = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
    }
    
    @objc func handleTap(_ sender:UITapGestureRecognizer) {
        if let navController = navigationController {
            navController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
