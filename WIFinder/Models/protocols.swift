//
//  protocols.swift
//  WIFinder
//
//  Created by Damian Modernell on 29/05/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

protocol TextDisplay {
    func getMainText() -> String
    func getSecondaryText() -> String
}

protocol ArtworkDisplay: class {
    var artWorkImageData:Data? { get set }
    var artworkUrl:URL { get set }
    func getImage(completion: @escaping (Data) -> ())
}

protocol Playable {
    var playableUrl:URL { get }
}

extension ArtworkDisplay {
    func getImage(completion: @escaping (Data) -> ()){
        
        let handler = { [weak self] (data:Data) -> () in
            self?.artWorkImageData = data
            completion(data)
        }
        
        guard let artWorkImagData = self.artWorkImageData else {
            ItunesMediaManager.getImage(url: self.artworkUrl, completion: handler)
            return
        }
        handler(artWorkImagData)
    }
}
