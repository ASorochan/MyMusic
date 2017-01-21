//
//  AlbumCollectionViewCell.swift
//  MyMusic
//
//  Created by Anatoly on 16.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit

import MediaPlayer

class AlbumCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    
    var mediaItem : MPMediaItem? {
        didSet {
           
            
            imageView.image = getArtworkImage(item: mediaItem!, ofSize: CGSize(width: frame.width / 2 , height: frame.height))
            
            
            
        }
    }
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .white
        addSubview(imageView)
        
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        
        
        
    }

    
}
