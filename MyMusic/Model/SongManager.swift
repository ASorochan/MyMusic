//
//  SongManager.swift
//  MyMusic
//
//  Created by Anatoly on 06.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer

class SongManager: NSObject {
    
    
    static let sharedManager = SongManager()
    let player = MPMusicPlayerController.systemMusicPlayer()
    let playerViewLauncher = PlayerViewLauncher()
    
    
    var songs: [MPMediaItem] = []
    var songsQuery = MPMediaQuery()
    var currentCollection: MPMediaItemCollection!
    var nowPlayingItemIndex = 0
    
    private override init() {
        super.init()
        
        
}
    func getAlbums() -> [MPMediaItemCollection] {
        
        let mediaQuery = MPMediaQuery.albums()
        var albums: [MPMediaItemCollection] = []
        
        let albumsItems = mediaQuery.collections
        
        for collection in albumsItems! {
            if let _ = collection.representativeItem {
                
                    albums.append(collection)
                
            }
        }
        return albums
    }
    
    func fetchAlbums(callback: @escaping (_ albums:[MPMediaItemCollection]) -> Void) {
        
        
        if MPMediaLibrary.authorizationStatus() == MPMediaLibraryAuthorizationStatus.authorized {
            
            callback(getAlbums())
            
        }else {
            MPMediaLibrary.requestAuthorization({ (status) in
                if status == MPMediaLibraryAuthorizationStatus.authorized {
                    let albums = self.getAlbums()
                    callback(albums)
                }
            })
        }

    }
    
    
    
    func getSongs() -> [MPMediaItem] {
        var songs:[MPMediaItem] = []
        let mediaQuery = MPMediaQuery.songs()
        
        let songItems = mediaQuery.items?.filter({(item) -> Bool in
            return item.mediaType == .music})
        
        for item in songItems! {
            songs.append(item)
            
        }
        
        
        if self.songs.isEmpty {
            self.songs = songs
            let collection = MPMediaItemCollection(items: songs)
            player.setQueue(with: collection)
        }
        return songs

        
    }
    
    func fetchSongs(callback: @escaping ((_ songs:[MPMediaItem]) -> Void)) {
        
        
        
        if MPMediaLibrary.authorizationStatus() == MPMediaLibraryAuthorizationStatus.authorized {
            
            callback(getSongs())
            
        }else {
            MPMediaLibrary.requestAuthorization({ (status) in
                if status == MPMediaLibraryAuthorizationStatus.authorized {
                    let songs = self.getSongs()
                    callback(songs)
                }
            })
        }
    }
    

    
    //MARK: - Player actions
    
    
    func playCollection(collection: MPMediaItemCollection, mediaItem: MPMediaItem) {
        currentCollection = nil
        currentCollection = collection
        player.setQueue(with: collection)
        guard let index = collection.items.index(of: mediaItem) else {return }
        nowPlayingItemIndex = index
        if mediaItem == player.nowPlayingItem {
            if let playerView = playerViewLauncher.playerView{
                playerView.handleTap()
                return
            }
        }
        
        let song = collection.items[index]
        
        player.nowPlayingItem = song
        if let playerView = playerViewLauncher.playerView{
            playerView.mediaItem = song
        }else {
            playerViewLauncher.showPlayer(mediaItem: song)
        }
        player.play()
        
    }
    
    func currentPlaybackState() -> MPMusicPlaybackState {
        return player.playbackState
    }
    
    func playItem(item:MPMediaItem) {
        
        currentCollection = nil
        currentCollection = MPMediaItemCollection(items: songs)
        player.setQueue(with: currentCollection)
        
        guard let index = songs.index(of: item) else {return }
        nowPlayingItemIndex = index
        if item == player.nowPlayingItem {
            if let playerView = playerViewLauncher.playerView{
                playerView.handleTap()
                return
            }
        }
        
        let song = currentCollection.items[index]
        
        
        player.nowPlayingItem = nil
        player.nowPlayingItem = song
        if let playerView = playerViewLauncher.playerView{
            playerView.mediaItem = song
        }else {
         playerViewLauncher.showPlayer(mediaItem: song)   
        }
        player.play()
    }

    func forward() {
       
        if nowPlayingItemIndex == currentCollection.items.count - 1 {
            nowPlayingItemIndex = 0
            player.nowPlayingItem = nil
            
            player.nowPlayingItem = currentCollection.items[nowPlayingItemIndex]
            
        }else {
            player.nowPlayingItem = nil
            
            player.nowPlayingItem = currentCollection.items[nowPlayingItemIndex]
            
            nowPlayingItemIndex += 1
            
        }
        if player.playbackState != .paused && player.playbackState != .stopped {
            player.play()
        }
        
        
    }
    
    func backward() {
        
        
        if nowPlayingItemIndex == 0 {
            nowPlayingItemIndex = currentCollection.count - 1
            player.nowPlayingItem = nil
            
            
            player.nowPlayingItem = currentCollection.items[nowPlayingItemIndex]
            if player.playbackState != .paused && player.playbackState != .stopped {
                player.play()
            }
            
        }else {
            player.nowPlayingItem = nil
           
            player.nowPlayingItem = currentCollection.items[nowPlayingItemIndex]
            nowPlayingItemIndex -= 1
            
            player.skipToPreviousItem()
            if player.playbackState != .paused && player.playbackState != .stopped {
                player.play()
            }
        }
    }
    
}
