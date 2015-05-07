//
//  CoffeeListViewController.swift
//  GetCoffee
//
//  Created by Yev Motov on 5/6/15.
//  Copyright (c) 2015 Achieve Motion, Inc. All rights reserved.
//

import UIKit

class CoffeeListViewController: UIViewController {
    
    let mapViewSegueIdentifier = "mapViewSegue"
    
    let locationManager = CLLocationManager()
    let coffeeDataProvider = CoffeeDataProvider()
    let refreshControl = UIRefreshControl()
    
    // coffee places fetched from google maps
    var coffeePlaces = [CoffeePlace]()
    
    // coffee place selected and passed to the map view controller
    var selectedCoffeePlace: CoffeePlace?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.customizeUI()
        self.startLocationUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeUI() {
        self.navigationItem.title = "Coffee Places"
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.tableView.tableFooterView = UIView()
    }
    
    func refresh(sender:AnyObject) {
        locationManager.startUpdatingLocation()
    }

}

// MARK: UITableViewDelegate, UITableViewDataSource
extension CoffeeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeePlaces.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CoffeePlaceCell", forIndexPath: indexPath) as! CoffeePlaceCell
        
        let coffeePlace = coffeePlaces[indexPath.row]
        
        cell.addressLabel.text = coffeePlace.placeVicinity
        cell.distanceLabel.text = "\(coffeePlace.distanceFromPresentation(location: coffeeDataProvider.currentLocation!))"
        cell.hoursLabel.text = coffeePlace.openingHours()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedCoffeePlace = coffeePlaces[indexPath.row]
        
        self.performSegueWithIdentifier(mapViewSegueIdentifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == mapViewSegueIdentifier {
            let destVC = segue.destinationViewController as! CoffeeMapViewController
            
            destVC.coffeePlace = selectedCoffeePlace
        }
    }
}

// MARK: CLLocationManagerDelegate
extension CoffeeListViewController: CLLocationManagerDelegate {
    
    func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func retrieveCoffeeData(#location: CLLocation) {
        coffeeDataProvider.fetchCoffeePlacesNearLocation(location) { (coffeeData, errorMessage) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                if self.refreshControl.refreshing {
                    self.refreshControl.endRefreshing()
                }
                
                if let coffeeData = coffeeData {
                    self.coffeePlaces = coffeeData
                    
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            locationManager.stopUpdatingLocation()
            
            self.retrieveCoffeeData(location: location)
        }
    }
}
