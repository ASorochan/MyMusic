//
//  AlbumSongsCollectionViewCell.swift
//  MyMusic
//
//  Created by Anatoly on 16.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import  MediaPlayer

class AlbumSongsCollectionViewCell: UICollectionViewCell {
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "song title"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    lazy var separatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    
    var mediaItem : MPMediaItem? {
        didSet {
            if let title = mediaItem!.title {
                titleLabel.text = "\(mediaItem!.albumTrackNumber).  \(title)"
            }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(separatorView)

        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 2).isActive = true
        
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
    }
    
}
