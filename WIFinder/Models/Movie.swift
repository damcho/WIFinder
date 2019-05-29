//
//  Movie.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class Movie: MediaObject, Playable {
    let movieName:String
    let longDescription:String?
    var playableUrl:URL

    override init?(data:MediaObjectDecoded) throws{
        self.movieName = data.trackName!
        self.longDescription = data.longDescription
        guard let previewUrl = data.previewURL else {
            return nil
        }
        self.playableUrl = previewUrl
        try super .init(data: data)
    }
    
   override func getSecondaryText() -> String {
        return self.longDescription == nil ? "" : self.longDescription!
    }
    
    override func getMainText() -> String {
        return self.movieName
    }
}
