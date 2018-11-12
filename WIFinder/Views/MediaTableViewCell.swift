//
//  MediaTableViewCell.swift
//  WIFinder
//
//  Created by Damian Modernell on 01/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    var mediaObject:MediaObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.artworkImageView.isUserInteractionEnabled = true
        self.artworkImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setMediaObject(mediaObject:MediaObject) {
        self.mediaObject = mediaObject
        self.mainLabel.text = mediaObject.getMainText()
        self.secondaryLabel.text = mediaObject.getSecondaryText()
        self.artworkImageView.image = nil
        mediaObject.getImage(completion: {[unowned self] (data:Data) ->() in
            self.artworkImageView.image = UIImage(data: data)
        })
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.artworkImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self!.artworkImageView.transform = .identity
        },
                       completion: nil)
    }
}
