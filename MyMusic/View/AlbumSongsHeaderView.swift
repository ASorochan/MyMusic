//
//  AlbumSongsHeaderView.swift
//  MyMusic
//
//  Created by Anatoly on 16.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer


class AlbumSongsHeaderView: UICollectionReusableView {

    lazy var albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    
    var mediaItem : MPMediaItem? {
        didSet {
            albumImageView.image = getArtworkImage(item: mediaItem!, ofSize: frame.size)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(albumImageView)
        albumImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        albumImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        albumImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        albumImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
