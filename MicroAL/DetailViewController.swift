//
//  DetailViewController.swift
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    // Set this before navigating to the view controller
    var serviceProvider:ServiceProvider?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var grade: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.serviceProvider!.name
        
        // Drop the pin
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: self.serviceProvider!.latitude!.doubleValue, longitude: self.serviceProvider!.longitude!.doubleValue)
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        
        // It would be good if the area of the map with the pin was actually visible
        self.mapView.centerCoordinate = coordinate
        
        // And it would be good if we weren't just viewing the entire planet
        let degreesSpan = 0.5
        let span = MKCoordinateSpan(latitudeDelta: degreesSpan, longitudeDelta: degreesSpan)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.region = region
    }
}
