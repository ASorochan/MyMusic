//
//  PlayerViewLauncher.swift
//  MyMusic
//
//  Created by Anatoly on 07.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewLauncher: NSObject {

    var view = UIView()
    var playerView : PlayerView!
    
    func showPlayer(mediaItem: MPMediaItem) {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {return}
        
            playerView = PlayerView(frame: keyWindow.frame)
            playerView.frame = CGRect(x: keyWindow.frame.width + smallPlayerSide,
                                      y: keyWindow.frame.height,
                                      width: smallPlayerSide ,
                                      height: smallPlayerSide)
            playerView.mediaItem = mediaItem
            keyWindow.addSubview(playerView)
            
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            self.playerView.frame = CGRect(x: keyWindow.frame.width - smallPlayerSide, y: keyWindow.frame.height - smallPlayerSide - tabBarHeight, width: smallPlayerSide, height: smallPlayerSide) },
                           completion: nil)
    }
    
    
}
