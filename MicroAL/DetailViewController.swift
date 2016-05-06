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
    
    var mapView = MKMapView()
    var textInfoView = UIView()
    var nameAndAddress = UIView()
    var name = UILabel()
    var address = UILabel()
    var reviewsAndGrade = UIView()
    var reviews = UILabel()
    var grade = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.textInfoView)
        
        self.textInfoView.addSubview(self.nameAndAddress)
        self.textInfoView.addSubview(self.reviewsAndGrade)
        
        self.nameAndAddress.addSubview(self.name)
        self.nameAndAddress.addSubview(self.address)
        
        self.reviewsAndGrade.addSubview(self.reviews)
        self.reviewsAndGrade.addSubview(self.grade)
    }
    
    private let mainViewSpacing:CGFloat = 20
    private let borderMargin:CGFloat = 20
    
    private func layoutViews() {
        var width:CGFloat
        var height:CGFloat
        
        // Getting a call to layoutViews (i.e., viewDidLayoutSubviews) on exiting the nav controller back to the master VC. Odd.
        if self.navigationController == nil {
            return
        }
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navStatusBarHeight = self.navigationController!.navigationBar.frameHeight + statusBarHeight
        let viewControllerHeight = self.view.frameHeight - navStatusBarHeight
        
        if self.view.frameWidth > self.view.frameHeight {
            // landscape
            width = self.view.frameWidth/2.0
            height = viewControllerHeight
        }
        else {
            // portrait
            width = self.view.frameWidth
            height = viewControllerHeight/2.0
        }
        
        width -= 2*self.borderMargin
        height -= 2*self.borderMargin
        
        let size = CGSize(width: width, height: height)
        self.mapView.frameSize = size
        self.textInfoView.frameSize = size
        
        self.mapView.frameY = navStatusBarHeight + self.borderMargin
        self.mapView.frameX = self.borderMargin
        
        if self.view.frameWidth > self.view.frameHeight {
            // landscape
            self.textInfoView.frameOrigin = CGPoint(x: self.mapView.frameMaxX + mainViewSpacing, y: navStatusBarHeight + self.borderMargin)
        }
        else {
            // portrait
            self.textInfoView.frameOrigin = CGPoint(x: self.borderMargin, y: self.mapView.frameMaxY + mainViewSpacing)
        }
        
        // We've got enough space vertically, so use it if we need it-- if we're cutting off the name/address text horizontally.
        self.name.numberOfLines = 1
        self.address.numberOfLines = 1
        self.name.sizeToFit()
        self.address.sizeToFit()
        
        func useTwoLinesIfNeededFor(label label:UILabel) {
            if label.frameWidth > width {
                label.numberOfLines = 2
                let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(FLT_MAX)))
                label.frameSize = size
            }
        }
        
        useTwoLinesIfNeededFor(label: self.name)
        useTwoLinesIfNeededFor(label: self.address)
        
        self.address.frameY = self.name.frameMaxY
        self.nameAndAddress.frameSize = CGSize(width: width, height: self.address.frameMaxY)
        
        self.reviewsAndGrade.frameWidth = width
        self.reviewsAndGrade.frameHeight = self.reviews.frameHeight
        self.grade.frameMaxX = self.reviewsAndGrade.frameWidth
        
        // Looks better, at least on iPhone to have this aligned with bottom
        self.reviewsAndGrade.frameMaxY = height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = self.serviceProvider!.name
        
        self.name.font = UIFont.systemFontOfSize(30)
        self.address.font = UIFont.systemFontOfSize(25)
        
        self.name.text = self.serviceProvider!.name
        self.address.text = "\(self.serviceProvider!.city!), \(self.serviceProvider!.state!) \(self.serviceProvider!.postalCode!)"
        self.reviews.text = "Reviews: \(self.serviceProvider!.reviewCount!)"
        self.grade.text = "Grade: \(self.serviceProvider!.overallGrade!)"
        
        // These are small enough to always fit. Don't worry about changing their size with rotation or amount of text.
        self.reviews.sizeToFit()
        self.grade.sizeToFit()
        
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
