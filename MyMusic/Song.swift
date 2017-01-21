//
//  Song.swift
//  MyMusic
//
//  Created by Anatoly on 06.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer

class Song: MPMediaItem {

    var titleName: String?
    var artistName: String?
    var duration: Double
    var image = Artwork()
    
    init(mediaItem: MPMediaItem) {
        if let title = mediaItem.title {
            self.titleName = title
        }
        if let artist = mediaItem.artist {
            self.titleName = artist
        }
        duration = mediaItem.playbackDuration
        if let artwork = mediaItem.artwork {
            self.image.artworkImage = artwork.image(at: CGSize(width: 256, height: 256))
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
