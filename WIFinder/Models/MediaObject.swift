//
//  MediaObject.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class MediaObject: TextDisplay, ArtworkDisplay {
    var artWorkImageData: Data?
    var artworkUrl:URL

    init?(data:MediaObjectDecoded) throws{
        guard let artWorkUrl = data.artworkURL else {
            return nil
        }
        self.artworkUrl = artWorkUrl
    }
    
    func getMainText() -> String {
        return ""
    }
    
    func getSecondaryText() -> String {
        return ""
    }
    
}




