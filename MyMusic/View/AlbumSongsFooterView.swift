//
//  AlbumSongsFooterView.swift
//  MyMusic
//
//  Created by Anatoly on 17.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer


class AlbumSongsFooterView: UICollectionReusableView {
    
    lazy var songsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        
        label.textAlignment = .left
        return label
    }()
    
    
    lazy var songsDurationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    
    var mediaItem: MPMediaItemCollection? {
        didSet {
            if mediaItem?.items.count == 1 {
                songsCountLabel.text = "1 Song"
                songsDurationLabel.text = formatTime(time: mediaItem!.items.first!.playbackDuration)
            }else {
                var totalDuration : Double = 0.0
                songsCountLabel.text = "\(mediaItem!.items.count) Songs"
                for item in mediaItem!.items {
                    totalDuration += item.playbackDuration
                }
                
                songsDurationLabel.text = formatTime(time: totalDuration)
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
        addSubview(songsCountLabel)
        addSubview(songsDurationLabel)
        
        songsCountLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        songsCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        songsCountLabel.widthAnchor.constraint(equalToConstant: frame.width / 2).isActive = true
        
        songsDurationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        songsDurationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        songsDurationLabel.widthAnchor.constraint(equalToConstant: frame.width / 2).isActive = true
        
        
    }
    
}
