//
//  TabBarViewController.swift
//  MyMusic
//
//  Created by Anatoly on 06.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTabBar()
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
    func setupTabBar() {
        let songViewController = SongsTableViewController()
        
        let songNav = UINavigationController(rootViewController: songViewController)
        let layout = AlbumCollectionViewLayout()
        
        let albumsCollecionViewController = AlbumsCollectionViewController(collectionViewLayout: layout)
        
        let albumNav = UINavigationController(rootViewController: albumsCollecionViewController)
        
        
        self.viewControllers = [songNav, albumNav]
        
        songViewController.tabBarItem = UITabBarItem(title: "Songs", image: UIImage(named:"song"), tag: 0)
        albumsCollecionViewController.tabBarItem = UITabBarItem(title: "Albums", image: UIImage(named:"album"), tag: 1)
        
        
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
