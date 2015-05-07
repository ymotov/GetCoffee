//
//  CoffeeMapViewController.swift
//  GetCoffee
//
//  Created by Yev Motov on 5/6/15.
//  Copyright (c) 2015 Achieve Motion, Inc. All rights reserved.
//

import UIKit

class CoffeeMapViewController: UIViewController {

    var coffeePlace: CoffeePlace?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let coffeePlaceLocation = coffeePlace?.placeLocation {
            mapView.animateToLocation(coffeePlaceLocation.coordinate)
            mapView.animateToZoom(17)
            
            var marker = GMSMarker(position: coffeePlaceLocation.coordinate)
            marker.title = coffeePlace!.placeVicinity
            marker.map = mapView
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        mapView.clear()
    }

}
