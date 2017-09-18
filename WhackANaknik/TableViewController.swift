//
//  TableViewController.swift
//  WhackANaknik
//
//  Created by neemdor semel on 14/09/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    private var searchResults: [Player] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backToMain(_ sender: UIButton) {
        performSegue(withIdentifier: "Back From Table", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        do{
            searchResults = try DBManager.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            return searchResults.count
        }catch{
            print("Error \(error)")
            return 0
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")

        if(searchResults != []){
            let result = searchResults[indexPath.row]
            cell.textLabel?.text = String(result.name!.padding(toLength: 25 - result.name!.characters.count, withPad: " ", startingAt: 0)+"\(result.score)")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Table To Map", sender: CLLocationCoordinate2D(latitude: searchResults[indexPath.row].latitude , longitude: searchResults[indexPath.row].longitude))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let theDestination = (segue.destination as? MapViewController){
            theDestination.defaultRegion = sender as? CLLocationCoordinate2D
        }
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
