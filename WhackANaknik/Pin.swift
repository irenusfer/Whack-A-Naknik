//
//  Pin.swift
//  WhackANaknik
//
//  Created by neemdor semel on 17/09/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject,MKAnnotation{
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate : CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
