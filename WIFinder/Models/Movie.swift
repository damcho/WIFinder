//
//  Movie.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class Movie: MediaObject {
    let trackName:String
    let longDescription:String?
    
    override init(data:MediaObjectDecoded) throws{
        self.trackName = data.trackName!
        self.longDescription = data.longDescription
        try super .init(data: data)

    }
    
    override func getSecondaryText() -> String {
        return self.longDescription == nil ? "" : self.longDescription!
    }
    
    override func getMainText() -> String {
        return self.trackName
    }
}
