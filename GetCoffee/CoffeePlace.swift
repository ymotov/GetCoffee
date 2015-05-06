//
//  CoffeePlace.swift
//  GetCoffee
//
//  Created by Yev Motov on 5/6/15.
//  Copyright (c) 2015 Achieve Motion, Inc. All rights reserved.
//

import Foundation

class CoffeePlace {
    
    // apple headquaters
    static let defaultLocation = CLLocation(latitude: 37.33072, longitude: -122.029674)
    
    let placeName: String
    let placeVicinity: String
    let placeLocation: CLLocation
    let isOpen: Bool?
    
    init(placeDict:[String: AnyObject]) {
        placeName = placeDict["name"] as? String ?? "Unknown"
        placeVicinity = placeDict["vicinity"] as? String ?? "Unknown"
        
        if let
            locationDict = placeDict["geometry"] as? [String: AnyObject],
            coordinateDict = locationDict["location"] as? [String: AnyObject],
            lat = coordinateDict["lat"] as? Double,
            lng = coordinateDict["lng"] as? Double
        {
            placeLocation = CLLocation(latitude: lat, longitude: lng)
        }
        else {
            placeLocation = CoffeePlace.defaultLocation
        }
        
        if let
            openingHoursDict = placeDict["opening_hours"] as? [String: AnyObject],
            openNow = openingHoursDict["open_now"] as? Bool
        {
            isOpen = openNow
        } else {
            isOpen = nil
        }
        
//        for(key, value) in placeDict {
//            println( "\(key) <> \(value)" )
//        }
    }
    
    func distanceFrom(#location: CLLocation) -> String {
        let distance = placeLocation.distanceFromLocation(location) * 0.000621371 // in miles
        return String(format: "%.1f mi", distance)
    }
    
    func openingHours() -> String {
        if let isOpen = isOpen {
            return isOpen ? "Open now" : "Closed now"
        }
        
        return "Could be closed by now"
    }
}