//
//  Protocols.swift
//  WIFinder
//
//  Created by Damian Modernell on 02/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

typealias QueryResut = ([MediaObject]?, Error?) -> ()

protocol DataConnector{
    
    func downloadImage(from url: URL, completion: @escaping (Data) -> ())

    func getMedia(searchParams: SearchObject, completionHandler: @escaping QueryResut)

}
