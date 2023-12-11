//
//  LocationManager.swift
//  GeoFenceTestApp
//
//  Created by Vaibhav on 12/11/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    private var locationManager : CLLocationManager!
    
    // MARK: - Singleton Instance
    static let instance = LocationManager()

    // MARK: - Initializer.
    override private init(){
        super.init()
    }

    func loadLocationManager(){
        initializeLocationManager()
    }
    
    /// Initializes the location manager with the desired settings.
    func initializeLocationManager() {
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.pausesLocationUpdatesAutomatically = false
            self.locationManager.activityType = .automotiveNavigation
            self.locationManager.requestAlwaysAuthorization()
        }
    }

    /// Starts monitoring the specified region.
    ///
    /// - Parameter region: The region to monitor.
    func startMonitoring(for region: CLRegion) {
        self.locationManager.startMonitoring(for: region)
    }

    /// Stops monitoring the specified region.
    ///
    /// - Parameter region: The region to stop monitoring.
    func stopMonitoring(for region: CLRegion) {
        self.locationManager.stopMonitoring(for: region)
    }

}

//MARK: - Location manager methods.
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        debugPrint("User Location Did Change", locations)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        GeofenceManager.shared.didEnterRegion(region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        GeofenceManager.shared.didExitRegion(region: region)
    }

}
