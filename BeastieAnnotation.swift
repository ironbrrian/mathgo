//
//  BeastieAnnotation.swift
//  pokemongo
//
//  Created by Brian Nguyen on
//  Copyright © 2023 Brian Nguyen. All rights reserved.
//

import UIKit
import MapKit

class BeastieAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon 
    }
}
