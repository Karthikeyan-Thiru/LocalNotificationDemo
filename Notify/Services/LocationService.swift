//
//  LocationService.swift
//  LocalNotification
//
//  Created by Karthikeyan T on 07/06/2020.
//  Copyright © 2020 Karthikeyan T. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService: NSObject {
    
    //1. Singleton Class
    private override init() { }
    static let sharedInstance = LocationService()
    
    //2. CompletionHandler
    var didUpdateLocation: ((CLLocation) -> Void)?
    
    //3. The CLLocationManager object is your entry point to the location service.
    let locationManager = CLLocationManager()
    
    //4. Boolean value to avoid multiple trigger
    var isRegionSet     = true
    
    //5. Request location authorization from the user
    func authorizeLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    //Get the location from the user
    func updateLocation() {
        isRegionSet = true
        locationManager.delegate = self
        
        //Check the Authorization Status
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .denied, .notDetermined, .restricted:
            locationManager.requestAlwaysAuthorization()
        default:
            //Start updating locations from GPS
            locationManager.startUpdatingLocation()
        }
    }
    
    //Get a circular geographic area with the given location and radius
    func getCurrentRegion(For location:CLLocation) -> CLCircularRegion {
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
        
        let region     = CLCircularRegion(center: coordinate,
                                          radius: circularRegionRadius,
                                          identifier: RegionIdentifier.home.rawValue)
        return region
    }
}


extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.first, isRegionSet else {return}
        didUpdateLocation?(currentLocation)
        isRegionSet = false
        locationManager.stopUpdatingLocation()
    }
}
