//
//  ViewController.swift
//  pokemongo
//
//  Created by Brian Nguyen on 2/11/23.
//  Copyright © 2023 Brian Nguyen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var update = 0
    
    var manager = CLLocationManager()
    
    // Compass Button
    @IBAction func userLocationUpdatedButtonPressed(_ sender: Any) {
        let region = MKCoordinateRegion.init(center: self.manager.location!.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        
        //Setting our location authorization status
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
            
            // this drops the little red pins every 5 seconds 
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                
                if let coordinate = self.manager.location?.coordinate{
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    
                    //randomizes token placement instead of straight line
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000))-500)/300000.0
                    
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000))-500)/300000.0
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
        } else{
            self.manager.requestWhenInUseAuthorization()
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // making geolocation efficient by not updating every second
        if update < 4 {
            let region = MKCoordinateRegion.init(center: self.manager.location!.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
            
            self.mapView.setRegion(region, animated: true)
            
            update += 1
        } else{
            
            self.manager.stopUpdatingLocation()
        }
     
    }
}

