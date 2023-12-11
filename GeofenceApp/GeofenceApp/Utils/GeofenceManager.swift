//
//  GeofenceManager.swift
//  GeoFenceTestApp
//
//  Created by Vaibhav on 12/11/23.
//

import Foundation
import CoreLocation

class GeofenceManager {
    
    static let shared = GeofenceManager.init()
    
    var didEnterGeofenceRegion: (() -> Void?)?
    var didExitGeofenceRegion: (() -> Void?)?

    var geofenceRegion: CLCircularRegion?

    /// Sets up and monitors a geofence with the specified location and radius.
    ///
    /// If an old geofence region exists, it stops monitoring it before creating and
    /// monitoring the new geofence region.
    ///
    /// - Parameters:
    ///   - location: The center coordinate of the geofence.
    ///   - radius: The radius of the geofence region.
    func setupAndMonitorGeofence(on location: CLLocationCoordinate2D, with radius: CGFloat) {
        // Step 1: Stop monitoring the old geofence region (if any)
        if let oldGeofenceRegion = geofenceRegion {
            LocationManager.instance.stopMonitoring(for: oldGeofenceRegion)
        }

        // Step 2: Create and start monitoring the new geofence region
        let geofenceRegion = CLCircularRegion(center: location,
                                              radius: CLLocationDistance(radius),
                                              identifier: "CohesionGeofence")
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true

        // Store the new geofence region
        self.geofenceRegion = geofenceRegion

        // Start monitoring the new geofence region
        LocationManager.instance.startMonitoring(for: geofenceRegion)
    }
    
}

//MARK: - Callbacks from Location manager on geofencing methods
extension GeofenceManager {
    
    func didEnterRegion(region: CLRegion){
        guard let geofenceRegion = geofenceRegion else{return}
        didEnterGeofenceRegion?()
        DataBaseHelper.shared.saveGeofenceData(geofenceData: GeofenceStruct.init(identifier: region.identifier,
                                                                                   latitude: geofenceRegion.center.latitude,
                                                                                   longitude: geofenceRegion.center.longitude,
                                                                                   timestamp: Date.init().timeIntervalSince1970,
                                                                                   entered: true))

    }
    
    func didExitRegion(region: CLRegion){
        guard let geofenceRegion = geofenceRegion else{return}
        didExitGeofenceRegion?()
        DataBaseHelper.shared.saveGeofenceData(geofenceData: GeofenceStruct.init(identifier: region.identifier,
                                                                                   latitude: geofenceRegion.center.latitude,
                                                                                   longitude: geofenceRegion.center.longitude,
                                                                                   timestamp: Date.init().timeIntervalSince1970,
                                                                                   entered: false))
    }
}
