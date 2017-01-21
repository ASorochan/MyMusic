//
//  AlbumsCollectionViewController.swift
//  MyMusic
//
//  Created by Anatoly on 07.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer


private let reuseIdentifier = "Cell"

class AlbumsCollectionViewController: UICollectionViewController {
    
    
    var albums : [MPMediaItemCollection] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let layout = collectionViewLayout as! AlbumCollectionViewLayout
        layout.delegate = self
        layout.numberOfColumns = 2
        collectionView?.backgroundColor = UIColor.colorWith(red: 49, green: 52, blue: 67)
        collectionView?.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.colorWith(red: 49, green: 52, blue: 67)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.statusBarBackgroundView.backgroundColor = UIColor.colorWith(red: 49, green: 52, blue: 67)
        
        if albums.isEmpty {
            fetchAlbums()
            
        }
        
        collectionView?.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchAlbums() {
        
        SongManager.sharedManager.fetchAlbums { (albums) in
            self.albums = albums
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
        
    }
    
    
    // MARK: UICollectionViewDataSource

   

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumCollectionViewCell
        
        
        if let item = albums[indexPath.item].representativeItem {
                cell.mediaItem = item
        }
       
    
        
    
        return cell
    }

    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = AlbumSongsCollectionViewLayout()
        let albumSongsVC = AlbumSongsCollectionViewController(collectionViewLayout: layout)
        albumSongsVC.mediaItem = self.albums[indexPath.item]
        self.navigationController?.pushViewController(albumSongsVC, animated: true)
    }
    
}


extension AlbumsCollectionViewController : AlbumCollectionViewLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let random = CGFloat(arc4random_uniform(2) + 1)
        return 200.0 + random * 50
    }
    
}
