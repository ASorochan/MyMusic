//
//  Utils.swift
//  MyMusic
//
//  Created by Anatoly on 06.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer

extension UIColor {
    
    static func colorWith(red:CGFloat, green: CGFloat,  blue: CGFloat) -> UIColor {
     return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}


func formatMediaItemArtistNameAndAlbumTitle(mediaItem:MPMediaItem) -> String {
    
    var artistName = ""
    var albumTitle = ""
    if let name = mediaItem.artist {
        artistName = name
    }
    if let title = mediaItem.albumTitle {
        albumTitle = title
    }
    
    if artistName != "" && albumTitle != "" {
        return "\(artistName) - \(albumTitle)"
    }
    if artistName != "" {
        return artistName
    }
    if albumTitle != "" {
        return albumTitle
    }
    
    return ""
}


func formatTime(time:Double) -> String {
    var formatedString = ""
    
    if time > 3600.0 {
        formatedString = String(format: "%02d:%02d:%02d", Int(time / 3600), Int((time / 60).truncatingRemainder(dividingBy: 60)),
                                Int(time.truncatingRemainder(dividingBy: 60)))
    }else {
        formatedString = String(format: "%02d:%02d", Int(time / 60), Int(time.truncatingRemainder(dividingBy: 60)))
    }
    
    return formatedString
}


func getArtworkImage(item:MPMediaItem, ofSize: CGSize) -> UIImage? {
//    if let artwork = item.artwork {
//        
//       return autoreleasepool(invoking: { () -> UIImage? in
//            if let image = artwork.image(at: ofSize) {
//                
//                return image
//            }else {
//                return UIImage(named: "no_image")
//            }
//            
//        })
//        
//        
//        
//    }
//    return UIImage(named: "no_image")

    var image: UIImage? = nil

    autoreleasepool {
        if let artwork = item.artwork {
            autoreleasepool {
                
                if let img = artwork.image(at: ofSize) {
                    image = img
                }
            }
        }
    }
    if image == nil {
        return UIImage(named: "no_image")
    }
    
    
    return image
}

let tabBarHeight: CGFloat = 49.0
let smallPlayerSide: CGFloat = 64.0

let customGray = UIColor.colorWith(red: 49, green: 52, blue: 67)




