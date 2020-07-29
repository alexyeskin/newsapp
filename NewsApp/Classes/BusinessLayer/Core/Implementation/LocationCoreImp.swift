//
//  LocationCoreImp.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/8/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import CoreLocation
import Foundation

class LocationCoreImp: NSObject, LocationCore {
    var locationManager: CLLocationManager = CLLocationManager()
    var locationHandler: ((Result<Location, LocationError>) -> Void)?
    
    override init() {
        super.init()
        setup()
    }
    
    func getLocation(completion: @escaping (Result<Location, LocationError>) -> Void) {
        locationHandler = completion
        stopMonitoring()
        startMonitoring()
    }
    
    private func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers //вроде бы точность
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    private func startMonitoring() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestLocation()
    }
    
    private func stopMonitoring() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}

extension LocationCoreImp: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let handler = locationHandler else {
            return
        }
        guard let location = locations.first else {
            handler(.failure(.notFound))
            return
        }
        
        let result = Location(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        handler(.success(result))
        
        locationHandler = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            locationHandler?(.failure(.denied))
        }
    }
    
    func geocodeLocation(location: Location, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if error == nil {
                let firstLocation = placemarks?.first
                let currentCountry = firstLocation?.country
                completion(currentCountry ?? "")
            } else {
                print("geocoder error")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error locationManager didFailWithError: \(error.localizedDescription)")
    }
}
