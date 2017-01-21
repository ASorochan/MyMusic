//
//  SongTableViewCell.swift
//  MyMusic
//
//  Created by Anatoly on 06.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer


class SongTableViewCell: UITableViewCell {
    
    let albumImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    let artistLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    var mediaItem: MPMediaItem? {
        didSet {
            
            if let title = mediaItem?.title {
                titleLabel.text = title
                
                
            }
            if let artist = mediaItem?.artist {
                artistLabel.text = artist
            }
            albumImageView.image = getArtworkImage(item: mediaItem!, ofSize:CGSize(width: 48.0, height: 48.0))
            
        }
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func setupView() {
        self.addSubview(albumImageView)
        self.addSubview(titleLabel)
        self.addSubview(artistLabel)
        
        
        albumImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        albumImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        albumImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: albumImageView.rightAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        
        artistLabel.leftAnchor.constraint(equalTo: albumImageView.rightAnchor, constant: 8).isActive = true
        artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        artistLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        artistLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        
    }
    
}
