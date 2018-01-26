//
//  FlickrTableViewController.swift
//  Adaptive Flickr Search
//
//  Created by Errol Cheong on 2018-01-22.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//

import UIKit

class FlickrTableViewController: UITableViewController {
    
    var categories = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach{tableView.deselectRow(at: $0, animated: animated)}
        }
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? ImageCollectionViewController, let selectedCell = tableView.indexPathForSelectedRow {
            let category = categories[selectedCell.row]
            dvc.title = category
            dvc.tag = category
        }
    }
    
    @IBAction func addCategoryTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add new search category", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField) in
            textField.font = UIFont.preferredFont(forTextStyle: .body)
        }
        let confirmButton = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            if let newCategory = alertController.textFields?.first?.text, !newCategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  {
                self.categories.append(newCategory)
            }
            self.dismiss(animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        [confirmButton, cancelButton].forEach{alertController.addAction($0)}
        present(alertController, animated: true, completion: nil)
    }

    
}
