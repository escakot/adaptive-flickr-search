//
//  NetworkManager.swift
//  Adaptive Flickr Search
//
//  Created by Errol Cheong on 2018-01-23.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    func queryImages(with tag:String, completionHandler: @escaping ([String: AnyObject]) -> Void) {
        var components = URLComponents(string: "https://api.flickr.com")
        components?.path = "/services/rest/"
        let queryItem1 = URLQueryItem(name: "method", value: "flickr.photos.search")
        let queryItem2 = URLQueryItem(name: "format", value: "json")
        let queryItem3 = URLQueryItem(name: "nojsoncallback", value: "1")
        let queryItem4 = URLQueryItem(name: "api_key", value: Constants.api_key)
        let queryItem5 = URLQueryItem(name: "tags", value: tag)
        components?.queryItems = [queryItem1, queryItem2, queryItem3, queryItem4, queryItem5];
        
        guard let requestURL = components?.url else {
            return;
        }
        //    print("\(url!)\n\(requestURL)")
        let request = URLRequest(url: requestURL)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if (error != nil)
            {
                print (error!.localizedDescription)
            } else {
                do {
                    if let photoData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject], let photoArray = photoData["photos"] as? [String:AnyObject] {
                        completionHandler(photoArray)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
        dataTask.resume()
    }
}
