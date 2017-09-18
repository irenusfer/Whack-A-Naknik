//
//  MapViewController.swift
//  WhackANaknik
//
//  Created by neemdor semel on 14/09/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController {
    private var searchResults: [Player] = []
    var defaultRegion: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backToMain(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let distanceSpan:CLLocationDegrees = 2000
        
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        do{
            searchResults = try DBManager.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            if(defaultRegion == nil){
                if(searchResults.count>0){
                    mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: searchResults[0].latitude,longitude: searchResults[0].longitude), distanceSpan, distanceSpan), animated: true)
                }else{
                    mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 32.115046,longitude: 34.817779), distanceSpan, distanceSpan), animated: true)
                }
            }else{
                mapView.setRegion(MKCoordinateRegionMakeWithDistance(defaultRegion!, distanceSpan, distanceSpan), animated: true)
            }
            for result in searchResults as [Player]{
                print(result.name!+" ,\(result.score), \(result.latitude), \(result.longitude)")
                
                let mapPin:Pin = Pin(title: result.name!,subtitle: "\(result.score)",coordinate: CLLocationCoordinate2D(latitude: result.latitude,longitude: result.longitude))
                mapView.addAnnotation(mapPin)
            }
        }catch{
            print("Error \(error)")
        }

        // Do any additional setup after loading the view.
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
