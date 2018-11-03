//
//  ItunesAPIConnector.swift
//  WIFinder
//
//  Created by Damian Modernell on 30/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class ITunesMediaAPIConnector : DataConnector{
    
    static let shared = ITunesMediaAPIConnector()
    
    let baseURL = "https://itunes.apple.com/"
    let searchURL = "search"
    let defaultSession:URLSession
    var dataTask: URLSessionDataTask?
    var errorMessage:String?
    
    init() {
        defaultSession = URLSession(configuration: .default)
    }
    
    func getMedia(searchParams: SearchObject, completionHandler: @escaping QueryResut) {
        
        if var urlComponents = URLComponents(string: baseURL + searchURL) {
            urlComponents.query = searchParams.urlString()
            
            print(urlComponents)
            guard let url = urlComponents.url else { return }
            self.requestMedia(url: url, completionHandler: completionHandler)
        }
    }
    
    func requestMedia(url: URL, completionHandler: @escaping ([MediaObject]?, String?) -> ()){
        self.errorMessage = nil

        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                self.errorMessage = "DataTask error: " + error.localizedDescription + "\n"
                DispatchQueue.main.async {
                    completionHandler(nil, self.errorMessage)
                }
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                let mediaObjects = try? MediaObjectDecoder.decode(data: data)
                if mediaObjects == nil {
                    self.errorMessage = "Error decoding data"
                } else if mediaObjects?.count == 0 {
                    self.errorMessage = "No results for your search"
                }
                DispatchQueue.main.async {
                    completionHandler(mediaObjects,self.errorMessage )
                }
            }
        }
        dataTask?.resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (Data) -> ()) {

        let completionHandler = { (data:Data?, response:URLResponse?, error:Error?) in
        
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(data)
            }
        }
        
        self.defaultSession.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
