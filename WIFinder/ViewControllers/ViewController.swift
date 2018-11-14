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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AVPlayerViewControllerDelegate {
    
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var itunesMediaManager:ItunesMediaManager?
    var searchObject:SearchObject = SearchObject()
    var player:AVPlayer?
    var activityIndicatorView:NVActivityIndicatorPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itunesMediaManager = ItunesMediaManager()
        self.filterSegmentedControl.selectedSegmentIndex = 0
        self.tableView.isHidden = true
        self.searchBar.placeholder = "ex: jenifer lopez"
        
        activityIndicatorView = NVActivityIndicatorPresenter.sharedInstance
    }
    
    @IBAction func filterControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = MediaType(rawValue: sender.selectedSegmentIndex)!
        self.searchObject.mediaType = selectedSegment
    }
    
    func showAlertView(error:Error) -> () {
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        if let error = self.searchObject.validate(){
            self.showAlertView(error:error)
        } else {
            let handler = { [unowned self] (mediaObjects:[MediaObject]?, error:Error?) -> () in
                if error != nil {
                    self.showAlertView(error: error!)
                } else {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
                self.activityIndicatorView?.stopAnimating(nil)
            }
            
            let activityData = ActivityData()
            activityIndicatorView?.startAnimating(activityData, nil)
            itunesMediaManager!.searchForMedia(searchObject: self.searchObject, completionHandler:handler)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itunesMediaManager!.getMediaObjectsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell:MediaTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MediaViewCell", for: indexPath as IndexPath) as! MediaTableViewCell
        
        cell.setMediaObject(mediaObject: self.itunesMediaManager!.getMediaObject(index:indexPath.row))
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchObject.term = searchText
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.player?.pause()
        let mediaObject = self.itunesMediaManager!.getMediaObject(index:indexPath.row)
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
        self.player!.play()
    }
}

