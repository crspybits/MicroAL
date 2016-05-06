//
//  DetailViewController.swift
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // Set this before navigating to the view controller
    var serviceProvider:ServiceProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.serviceProvider!.name
    }
}
