//
//  SearchObject.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

class SearchObject {
    
    var mediaType:MediaType
    var term:String?
    
    init() {
        self.mediaType = MediaType.ALLMEDIA
    }
    
    
    func urlString() -> String {
        var urlParams = ""
        if self.term != nil {
            let termString = self.term!.replacingOccurrences(of: " ", with: "+")
            urlParams += "term=" + termString
        }
        
        switch self.mediaType {
        case .ALLMEDIA:
            urlParams += "&media=all"
        case .MOVIE:
            urlParams += "&media=movie"
        case .MUSIC:
            urlParams += "&media=music"
        case .TVSHOW:
            urlParams += "&media=tvShow"
            
        }
        return urlParams
    }
    
}
