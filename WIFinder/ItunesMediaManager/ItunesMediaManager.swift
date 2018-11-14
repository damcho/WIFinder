//
//  ItunesMediaManager.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

class ItunesMediaManager {
    
    let mediaConnector:DataConnector
    var mediaObjects:[MediaObject]?
    
    init() {
        self.mediaConnector = ITunesMediaAPIConnector.shared
    }
    
    func searchForMedia(searchObject:SearchObject, completionHandler: @escaping QueryResut) {
        let completion:QueryResut = { [unowned self] (modelObjects:[MediaObject]?, errormsg:Error?) -> () in
            self.mediaObjects = modelObjects
            completionHandler(modelObjects, errormsg)
        }
        
        self.mediaConnector.getMedia(searchParams:searchObject, completionHandler:completion)
    }
    
    func getMediaObjectsCount() -> Int {
        return self.mediaObjects == nil ? 0 : self.mediaObjects!.count
    }
    
    func getMediaObject(index:Int) -> MediaObject  {
        return self.mediaObjects![index]        
    }
    
    class func getImage(url:URL, completion: @escaping (Data) -> ()){
        ITunesMediaAPIConnector.shared.downloadImage(from:url, completion:completion)
    }

}
