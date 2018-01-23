//
//  FlickrTableViewController.swift
//  Adaptive Flickr Search
//
//  Created by Errol Cheong on 2018-01-22.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//

import UIKit

class FlickrTableViewController: UITableViewController {
    
    let networkManager = NetworkManager()
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath), let tag = cell.textLabel?.text {
            networkManager.queryImages(with: tag, completionHandler: { (jsonData) in
                if let photos = jsonData["photo"] as? [[String: AnyObject]] {
                    let flickrImages = photos.map{Photo.init(data: $0)}
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "DetailSegue", sender: flickrImages)
                    }
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ImageCollectionViewController, let flickrImages = sender as? [Photo] {
            dvc.flickrImages = flickrImages
        }
    }
}