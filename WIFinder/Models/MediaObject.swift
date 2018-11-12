//
//  MediaObject.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class MediaObject {
    
    let artworkUrl:URL
    var previewURL:URL?
    var artWorkImageData:Data?

    init(data:MediaObjectDecoded) throws{
        artworkUrl = data.artworkURL
        previewURL = data.previewURL
        
    }
    
    func getSecondaryText() -> String {
        return ""
    }
    
    func getMainText() -> String {
        return ""
    }
    
    func getImage(completion: @escaping (Data) -> ()){
        
        let handler = { [unowned self] (data:Data) -> () in
            self.artWorkImageData = data
            completion(data)
        }
        
        if self.artWorkImageData != nil {
            handler(self.artWorkImageData!)
        } else {
            ItunesMediaManager.getImage(url: self.artworkUrl, completion: handler)
        }
    }
}




