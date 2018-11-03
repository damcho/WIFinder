//
//  SearchObject.swift
//  WIFinder
//
//  Created by Damian Modernell on 31/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

enum filterType : String{
    case song
    case movie
    case tvShow
    case all
}

class SearchObject {
    
    var mediaFilter:filterType
    var term:String?
    
    init() {
        self.mediaFilter = filterType.all
    }
    
    
    func urlString() -> String {
        var urlParams = ""
        if self.term != nil {
            let termString = self.term!.replacingOccurrences(of: " ", with: "+")
            urlParams += "term=" + termString
        }
        
        switch self.mediaFilter {
        case filterType.all:
            urlParams += "&media=all"
        case filterType.movie:
            urlParams += "&media=movie"
        case filterType.song:
            urlParams += "&media=music"
        case filterType.tvShow:
            urlParams += "&media=tvShow"
            
        }
        return urlParams
    }
    
    func validate() -> Bool {
        return self.term != nil && self.term != ""
    }
    
}
