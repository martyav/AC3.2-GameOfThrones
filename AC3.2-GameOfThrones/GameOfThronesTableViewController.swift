//
//  GameOfThronesTableViewController.swift
//  AC3.2-GameOfThrones
//
//  Created by Jason Gresh on 10/11/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class GameOfThronesTableViewController: UITableViewController {
    
    var episodes = [GOTEpisode]()
    var chosenEpisode: GOTEpisode?
    
    func loadData() {
        
// we need to unwrap the episodes and then throw that data into the cells
        
        guard let path = Bundle.main.path(forResource: "got", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options:  NSData.ReadingOptions.mappedIfSafe),
            let dict = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as? NSDictionary else {
                return
        }
        
        if let episodes = dict?.value(forKeyPath: "_embedded.episodes") as? [[String:Any]] {
            for epDict in episodes {
                if let ep = GOTEpisode(withDict: epDict) {
                    self.episodes.append(ep)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        dump(episodes)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count // should generally match the number of items in our array
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eppy", for: indexPath)

        // MARK: - Populating the cell

        let thisCellsEpisode = self.episodes[indexPath.row]
        cell.textLabel?.text = "Episode \(thisCellsEpisode.number): \(thisCellsEpisode.name)" // this calls up the main text label -- in this case, the one named title in the storyboard. we may think we're "creating" the label but it's already waiting for us. this is more clear when we use a basic or detail cell style. we just don't have to create an outlet for it using control-drag, which is a little confusing
        cell.detailTextLabel?.text = thisCellsEpisode.airdate // when we have a detail cell style this calls up the little text below or beside the title. using styles means we don't have to worry so much about messing with constraints
 
        // Styling
        
        cell.textLabel?.font = UIFont(name: "Baskerville-Semibold", size: 16)
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        chosenEpisode = episodes[indexPath.row]
//        performSegue(withIdentifier: "episodeSegue", sender: chosenEpisode)
//    }

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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "episodeSegue",
            let destination = segue.destination as? EpisodeDeetsController,
            // Pass the selected object to the new view controller.
            let cell = sender as? UITableViewCell,
            let ip = tableView.indexPath(for: cell) {
            let ep = self.episodes[ip.row]
            destination.chosenEpisode = ep
        }
    }
}
