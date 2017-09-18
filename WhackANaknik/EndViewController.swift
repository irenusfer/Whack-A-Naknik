//
//  EndViewController.swift
//  WhackANaknik
//
//  Created by neemdor semel on 18/08/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class EndViewController: UIViewController,CLLocationManagerDelegate {
    var score: Int?
    var playerName: String = ""
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    private var searchResults: [Player] = []
    private var resultChange = Player()
    private var overwrite:Bool = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var scoreTextLabel: UILabel!
    
    @IBAction func Restart(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func mainMenu(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func submitScore(_ sender: UIButton) {
        playerName = textField.text!
        
        // MARK: - save to DB
        if(!overwrite){
            if let player:Player = NSEntityDescription.insertNewObject(forEntityName: "Player", into: DBManager.getContext()) as? Player{
                player.name = playerName
                player.score = Int16(score!)
                if(currentLocation != nil){
                    player.latitude = (currentLocation?.coordinate.latitude)!
                    player.longitude = (currentLocation?.coordinate.longitude)!
                }else{
                    player.latitude = 0
                    player.longitude = 0
                }
            }
        }else{
            resultChange.setValue(playerName, forKey: "name")
            resultChange.setValue(Int16(score!), forKey: "score")
            
            if(currentLocation != nil){
                resultChange.setValue((currentLocation?.coordinate.latitude)!, forKey: "latitude")
                resultChange.setValue((currentLocation?.coordinate.longitude)!, forKey: "longitude")
            }else{
                resultChange.setValue(0, forKey: "latitude")
                resultChange.setValue(0, forKey: "longitude")
            }
        }
        
        locationManager?.stopUpdatingLocation()
        DBManager.saveContext()
    
        performSegue(withIdentifier: "Main Menu", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        if(score! >= 0){
            statusLabel.text = "You Win"
            ScoreLabel.text = "\(score!)"
            submitBtn.isHidden = true
            
            // MARK: - check DB
            let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: true)]
            do{
                searchResults = try DBManager.getContext().fetch(fetchRequest)
                print("number of results: \(searchResults.count)")
            }catch{
                print("Error \(error)")
                
            }
            if(searchResults.count<10){
                overwrite = false
                submitBtn.isHidden = false
                textField.isHidden = false
                nameLabel.isHidden = false
                
            }else{
                for result in searchResults as [Player]{
                    if(Int16(score!) > result.score){
                        resultChange = result
                        overwrite = true
                        submitBtn.isHidden = false
                        textField.isHidden = false
                        nameLabel.isHidden = false
                        break
                    }
                }
                if(!overwrite){
                    submitBtn.isHidden = true
                    textField.isHidden = true
                    nameLabel.isHidden = true
                }
            }
            
        }else{
            statusLabel.text = "You Lose"
            ScoreLabel.text = ""
            submitBtn.isHidden = true
            scoreTextLabel.isHidden = true
            textField.isHidden = true
            nameLabel.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - get location
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager?.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
