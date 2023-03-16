//
//  ViewController.swift
//  pokemongo
//
//  Created by Brian Nguyen on 2/11/23.
//  Copyright © 2023 Brian Nguyen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var update = 0
    
    var manager = CLLocationManager()
    
    var pokemons: [Pokemon] = []
    
    // Compass Button
    @IBAction func userLocationUpdatedButtonPressed(_ sender: Any) {
        let region = MKCoordinateRegion.init(center: self.manager.location!.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        pokemons = bringAllPokemons()
        
        
        //Setting our location authorization status
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            self.mapView.delegate = self 
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
            
            // this drops the little red pins every 5 seconds 
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                
                if let coordinate = self.manager.location?.coordinate{
                    //random beastie from our array
                    
                    //annotation.coordinate = coordinate
                    let randomPokemon = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                    //gives us random pokemon we can pass
                    let pokemon = self.pokemons[randomPokemon]
                    
                    //Update annotation with class we created
                    let annotation = BeastieAnnotation(coordinate: coordinate, pokemon: pokemon)
                    //annotation.coordinate = coordinate
                    
                    
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
    // mask annotation with image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let image = UIImage(named: "train")
        //let image2 = UIImage(named:"pikachu")
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation{
            annotationView.image = image
        } else{
            let pokemon = (annotation as! BeastieAnnotation).pokemon
            annotationView.image = UIImage(named: pokemon.imageFileName!)
        }
        //create new frame because images are oversized
        var newFrame = annotationView.frame
        newFrame.size.height = 40
        newFrame.size.width = 40
        annotationView.frame = newFrame
        
        return annotationView
    }
    
    //this lets you know if you clicked on a beastie
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // we dont want to be locked on, so deselect
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        // if its the player icon selected , do nothing
        if view.annotation! is MKUserLocation {
            return
        }
        let region = MKCoordinateRegion.init(center: view.annotation!.coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
        
        self.mapView.setRegion(region, animated: false)
        
        // if within region, give feedback wheter too far or close 
        if let coordinate = self.manager.location?.coordinate{
            if mapView.visibleMapRect.contains(MKMapPoint(coordinate)){
                let battle = CaptureViewController()
                
                let pokemon = (view.annotation as! BeastieAnnotation).pokemon
                
                battle.pokemon = pokemon
                self.mapView.removeAnnotation(view.annotation!)
                
                self.present(battle, animated: true, completion: nil)
                //print("Within Range")
            }else{
                print("Too far")
            }
        }

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

