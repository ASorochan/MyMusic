//
//  AlbumSongsCollectionViewController.swift
//  MyMusic
//
//  Created by Anatoly on 16.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer


private let reuseIdentifier = "Cell"
private let headerIdentifier = "Header"
private let footerIdentifier = "Footer"

class AlbumSongsCollectionViewController: UICollectionViewController {
    
    
    
    var mediaItem: MPMediaItemCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        

        self.collectionView!.register(AlbumSongsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.register(AlbumSongsHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        self.collectionView?.register(AlbumSongsFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.headerReferenceSize = CGSize(width: collectionView!.bounds.width, height: collectionView!.bounds.height / 3)
        layout.footerReferenceSize = CGSize(width: collectionView!.bounds.width, height: 56)
        // Do any additional setup after loading the view.
        layout.itemSize = CGSize(width: collectionView!.bounds.width, height: 56)
        collectionView?.backgroundColor = UIColor.colorWith(red: 49, green: 52, blue: 67)
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = .clear
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.statusBarBackgroundView.backgroundColor = .clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

  

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        
        return mediaItem!.items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumSongsCollectionViewCell
    
        if let item = mediaItem?.items[indexPath.item] {
            cell.mediaItem = item
        }
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        

        if kind == UICollectionElementKindSectionHeader {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! AlbumSongsHeaderView
            
                    if let item = mediaItem?.representativeItem {
                        view.mediaItem = item
                    }
                    
                    return view
        }else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as! AlbumSongsFooterView
            
                view.mediaItem = mediaItem
            
            
            return view
        }
        
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = mediaItem!.items[indexPath.item]
        SongManager.sharedManager.playCollection(collection: mediaItem!, mediaItem: item)
    }
    
 
}


extension AlbumSongsCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 56)
    }
    
}
