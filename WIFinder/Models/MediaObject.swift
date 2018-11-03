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
    var artWirkImageDate:Data?

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
        
        let handler = { (data:Data) -> () in
            self.artWirkImageDate = data
            completion(data)
        }
        
        if self.artWirkImageDate != nil {
            handler(self.artWirkImageDate!)
        } else {
            ItunesMediaManager.getImage(url: self.artworkUrl, completion: handler)
        }
    }
}




