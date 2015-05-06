//
//  CoffeeDataProvider.swift
//  GetCoffee
//
//  Created by Yev Motov on 5/6/15.
//  Copyright (c) 2015 Achieve Motion, Inc. All rights reserved.
//

import Foundation

protocol httpMethods {
    func httpGet(requestURL: NSURL, callback: (resultData: NSData?, errorMessage: String?) -> Void) -> Void
}

class CoffeeDataProvider {
    
    let apiKey = "AIzaSyCpM5TPSTe-F32P3r63rsCnVZ9NeLNDWwo"
    
    var currentLocation: CLLocation?
    
    func fetchCoffeePlacesNearLocation(
        location: CLLocation,
        completion:(coffeeData: [CoffeePlace]?, errorMessage: String?) -> Void)
    {
        // that's a value that could potentially be configured via UI.
        let radius = 5000
        
        // cache current location
        currentLocation = location
        
        var url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&radius=\(radius)&name=starbucks&key=\(apiKey)"
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        self.httpGet(NSURL(string: url)!, callback: { (resultData, errorMessage) -> Void in
            if let errorMessage = errorMessage {
                completion(coffeeData: nil, errorMessage: errorMessage)
                return
            }
            
            var coffeePlaces = [CoffeePlace]()
            
            if let
                resultData = resultData,
                json = NSJSONSerialization.JSONObjectWithData(resultData, options: nil, error: nil) as? [String: AnyObject],
                results = json["results"] as? [[String: AnyObject]]
            {
                for place in results {
                    coffeePlaces.append(CoffeePlace(placeDict: place))
                }
            }
            
            // sort fetched array to have the nearest location on top.
            coffeePlaces.sort({$0.distanceFrom(location: self.currentLocation!) < $1.distanceFrom(location: self.currentLocation!)})
            
            completion(coffeeData: coffeePlaces, errorMessage: nil)
        })
    }
}

extension CoffeeDataProvider: httpMethods {
    
    func httpGet(requestURL: NSURL, callback: (resultData: NSData?, errorMessage: String?) -> Void) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(requestURL) { (data, response, error) -> Void in
            if error != nil {
                callback(resultData: nil, errorMessage: error.localizedDescription)
            } else {
                callback(resultData: data, errorMessage: nil)
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        task.resume()
    }
}