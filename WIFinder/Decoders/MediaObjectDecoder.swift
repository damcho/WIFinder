//
//  MediaObjectDecoder.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class MediaObjectDecoder {
    
    
    class func decode(data:Data) throws -> [MediaObject]{
        let decodedMediaObject =  try  JSONDecoder().decode(DecodedMediaObjects.self, from: data)
        
        var mediaObjects:[MediaObject] = Array()
        for decodedObject in decodedMediaObject.results {
            if decodedObject.kind != nil {

                switch decodedObject.kind {
                    
                case "song":
                    if let mediaObj = try Song(data:decodedObject) {
                        mediaObjects.append(mediaObj)
                    }
                case "feature-movie":
                    if let mediaObj = try Movie(data:decodedObject) {
                        mediaObjects.append(mediaObj)
                    }
                case "tv-episode":
                    if let mediaObj = try TVShow(data:decodedObject) {
                        mediaObjects.append(mediaObj)
                    }
                default:
                    break
                }
            }
        }
        
        return mediaObjects
    }
}

private struct DecodedMediaObjects : Decodable {
    let resultCount:Int
    let results:[MediaObjectDecoded]
}


struct MediaObjectDecoded :Decodable {
    
    let kind:String?
    let artistName:String
    let longDescription:String?
    let trackName:String?
    let artworkURL:URL?
    let previewURL:URL?
    
    enum CodingKeys : String, CodingKey {
        case kind = "kind"
        case artistName = "artistName"
        case longDescription = "longDescription"
        case previewURL = "previewUrl"
        case artworkURL = "artworkUrl100"
        case trackName = "trackName"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.kind = try? container.decode(String.self, forKey: .kind)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.longDescription = try? container.decode(String.self, forKey: .longDescription)
        self.previewURL = try? container.decode(URL.self, forKey: .previewURL)
        self.artworkURL = try? container.decode(URL.self, forKey: .artworkURL)
        self.trackName = try? container.decode(String.self, forKey: .trackName)
    }
}

