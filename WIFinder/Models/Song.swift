//
//  Song.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//
import AVFoundation
import Foundation

class Song: MediaObject {
    let artistName:String
    let trackName:String
    var audioPlayer:AVPlayer?

    override init(data:MediaObjectDecoded) throws{
        self.artistName = data.artistName
        self.trackName = data.trackName!
        try super.init(data: data)
    }
    
    override func getSecondaryText() -> String {
        return self.artistName
    }
    
    override func getMainText() -> String {
        return self.trackName
    }
}

