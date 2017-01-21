//
//  SongsTableViewController.swift
//  MyMusic
//
//  Created by Anatoly on 06.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer


class SongsTableViewController: UITableViewController {
    
    let cellId = "cellId"
    
    
    var sectionsTitles: [String] = []
    var songDict: [String: [MPMediaItem]] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.tableView.register(SongTableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        self.view.backgroundColor = .white
        self.tableView.sectionIndexColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.statusBarBackgroundView.backgroundColor = UIColor.colorWith(red: 49, green: 52, blue: 67)
        if self.songDict.isEmpty {
            fetchSongs()
        }
    }
    
    
    func fetchSongs() {
        
        SongManager.sharedManager.fetchSongs { (songs) in
            
            self.createSongDict(songs: songs)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionsTitles
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionsTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitles[section]
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = sectionsTitles[section]
        if let songs = songDict[key] {
            return songs.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SongTableViewCell
        let key = sectionsTitles[indexPath.section]
        
        if let songs = songDict[key] {
            cell.mediaItem = songs[indexPath.row]
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    
    func createSongDict(songs: [MPMediaItem]) {
        for song in songs {
            guard let title = song.title else {continue}
            var key = title.substring(to: title.characters.index(after: title.startIndex))
            
            
            if key == " " {
                
                guard let index = title.index(title.startIndex, offsetBy: 2, limitedBy: title.endIndex) else {continue}
                
                key = title.substring(to: index).replacingOccurrences(of: " ", with: "")
            }
            if var sectionSongs = songDict[key] {
                sectionSongs.append(song)
                songDict[key] = sectionSongs
            } else {
                songDict[key] = [song]
            }
        }
        
        sectionsTitles = [String](songDict.keys)
        sectionsTitles = sectionsTitles.sorted(by: {$0 < $1})
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = sectionsTitles[indexPath.section]
        
        if let songs = songDict[key] {
            let song = songs[indexPath.row]
            SongManager.sharedManager.playItem(item: song)
           
        }
    }
    

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
