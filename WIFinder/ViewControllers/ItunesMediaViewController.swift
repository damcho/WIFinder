//
//  ViewController.swift
//  WIFinder
//
//  Created by Damian Modernell on 30/10/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


enum MediaType:Int{
    case ALLMEDIA=0
    case MUSIC
    case TVSHOW
    case MOVIE
}

class ItunesMediaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AVPlayerViewControllerDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var itunesMediaManager:ItunesMediaManager?
    var searchObject:SearchObject = SearchObject()
    var player:AVPlayer?
    let activityData = ActivityData()
    var activityIndicatorView:NVActivityIndicatorPresenter = NVActivityIndicatorPresenter.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iTunes Media Search"
        self.itunesMediaManager = ItunesMediaManager()
        self.filterSegmentedControl.selectedSegmentIndex = 0
        self.filterSegmentedControl.isEnabled = false
        self.setupSearchController()
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.delegate = self
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.placeholder = "ex: bruce willis"
    }
    
    @IBAction func filterControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = MediaType(rawValue: sender.selectedSegmentIndex)!
        self.searchObject.mediaType = selectedSegment
        self.fetchMedia()
    }
    
    func showAlertView(error:Error) -> () {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itunesMediaManager?.getMediaObjectsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell:MediaTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MediaViewCell", for: indexPath as IndexPath) as! MediaTableViewCell
        
        cell.setMediaObject(mediaObject: (self.itunesMediaManager?.getMediaObject(index:indexPath.row))!)
        
        return cell
    }
    
    func fetchMedia() {
        let handler = { [weak self] (mediaObjects:[MediaObject]?, error:Error?) -> () in
            if error != nil {
                self?.showAlertView(error: error!)
            } else {
                self?.tableView.reloadData()
            }
            self?.tableView.isHidden = error == nil
            self?.activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        }
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        itunesMediaManager?.searchForMedia(searchObject: self.searchObject, completionHandler:handler)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.fetchMedia()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        self.searchObject.term = strippedString
        self.filterSegmentedControl.isEnabled = strippedString != "" ? true : false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.player?.pause()
        guard let mediaObject = self.itunesMediaManager?.getMediaObject(index:indexPath.row) else {
            return
        }
        if mediaObject.previewURL != nil {
            player = AVPlayer(url: mediaObject.previewURL!)
            if mediaObject is Movie || mediaObject is TVShow{
                self.playVideo()
            } else if mediaObject is Song {
                self.playAAudio()
            }
        }
    }
    
    func playVideo() {
        let playervc = AVPlayerViewController()
        playervc.delegate = self
        playervc.player = player
        self.present(playervc, animated: true) {
            playervc.player!.play()
        }
    }
    
    func playAAudio() {
        self.player?.play()
    }
}

