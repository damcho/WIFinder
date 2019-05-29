//
//  TVShow.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

class TVShow: MediaObject, Playable {
    let artistName:String
    let longDescription:String
    var playableUrl:URL
    
    override init?(data:MediaObjectDecoded) throws{
        self.artistName = data.artistName
        self.longDescription = data.longDescription!
        guard let previewUrl = data.previewURL else {
            return nil
        }
        self.playableUrl = previewUrl
        try super.init(data: data)
    
    }
    
    override func getSecondaryText() -> String {
        return self.longDescription
    }
    
    override func getMainText() -> String {
        return self.artistName
    }
}
