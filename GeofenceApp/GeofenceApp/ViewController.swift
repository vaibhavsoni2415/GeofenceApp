//
//  ViewController.swift
//  GeofenceApp
//
//  Created by Vaibhav on 12/11/23.
//

import UIKit

import MapKit
import CoreLocation

final class ViewController: UIViewController {

    @IBOutlet weak var navigationItemButton: UIButton!
    @IBOutlet weak var markerView: UIImageView!
    @IBOutlet weak var centerGeofenceButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    
    private var geofenceCircle: MKCircle?
    private var geofenceLocation: CLLocationCoordinate2D?
    private var navigationItemState: NavigationItemState = .create {
        didSet{
            updateNavigationItemAppereance()
        }
    }
    
    //MARK: - UIView lifecyle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.instance.loadLocationManager()
        DataBaseHelper.shared.loadDB()
        setupMapView()
        setupSubviews()
    }

}

//MARK: - Appereance methods.
extension ViewController {
    
    func updateNavigationItemAppereance(){
        switch navigationItemState {
        case .create:
            navigationItemButton.setTitle("Add", for: .normal)
            break
        case .edit:
            navigationItemButton.setTitle("Update", for: .normal)
            break
        case .done:
            navigationItemButton.setTitle("Done", for: .normal)
            break
        }
    }
}

// MARK: - Map & Core Location
fileprivate extension ViewController {

    /// Set up subviews including button styling.
    func setupSubviews() {
        centerGeofenceButton.clipsToBounds = false
        centerGeofenceButton.layer.cornerRadius = 25
        centerGeofenceButton.dropShadow()
    }

    /// Set up the map view with user location enabled and delegate assigned.
    func setupMapView() {
        mapview.showsUserLocation = true
        mapview.delegate = self
    }

    /// Load the geofence area on the map.
    ///
    /// - Note: This method removes the existing geofence circle overlay if it exists,
    /// creates a new circle overlay, adds it to the map, and sets up geofence monitoring.
    func loadGeofenceAreaOnMap() {
        guard let centerCoordinate = geofenceLocation else { return }

        // Remove existing geofence circle overlay if it exists
        if let geofenceCircle = self.geofenceCircle {
            self.mapview.removeOverlay(geofenceCircle)
        }

        // Create a new circle overlay
        let geofenceCircle = MKCircle(center: centerCoordinate, radius: FileConstant.circleRadius)

        // Add the circle overlay to the map
        mapview.addOverlay(geofenceCircle)
        self.geofenceCircle = geofenceCircle
        
        // Setup geofence region and monitor for enter and exit events.
        GeofenceManager.shared.setupAndMonitorGeofence(on: centerCoordinate, with: FileConstant.circleRadius)

    }
}

// MARK: - UIButton action methods.
extension ViewController {

    /// Handles the action when the "Add" button is pressed.
    @IBAction func actionOnAddButton(_ sender: Any) {
        if navigationItemState == .create {
            markerView.isHidden = false
            showPrompt(message: FileConstant.addGeofenceMessage)
            navigationItemState = .done
        } else if navigationItemState == .done {
            markerView.isHidden = true
            navigationItemState = .edit
            let center = CGPoint(x: markerView.center.x, y: markerView.frame.maxY)
            let coordinate = mapview.convert(center, toCoordinateFrom: self.view)
            debugPrint("Marker Center Coordinates - Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
            geofenceLocation = coordinate
            loadGeofenceAreaOnMap()
        } else {
            markerView.isHidden = false
            navigationItemState = .done
        }
    }

    /// Handles the action when the "Center Geofence Area" button is pressed.
    @IBAction func actionOnCenterGeofenceArea(_ sender: Any) {
        guard let centerCoordinate = geofenceLocation else { return }
        // Set the region to include the circle
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: FileConstant.circleRadius * 4, longitudinalMeters: FileConstant.circleRadius * 4)
        mapview.setRegion(region, animated: true)
    }
}

// MARK: - Private methods.
fileprivate extension ViewController {

    /// Shows a prompt message view with animation.
    ///
    /// - Parameter message: The message to be displayed in the prompt.
    func showPrompt(message: String) {
        let promptView = PromptView.instanceFromNib()
        promptView.clipsToBounds = false
        promptView.layer.cornerRadius = 10
        promptView.message = message
        promptView.tag = 11
        promptView.alpha = 0
        promptView.frame = CGRect(x: 20, y: -100, width: UIScreen.main.bounds.width - 40, height: 100)
        view.addSubview(promptView)
        UIView.animate(withDuration: 0.5) {
            promptView.alpha = 1
            promptView.frame = CGRect(x: 20, y: 80, width: UIScreen.main.bounds.width - 40, height: 100)
        } completion: { finished in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.removePrompt()
            }
        }
    }

    /// Removes the prompt message view with animation.
    func removePrompt() {
        if let view = view.viewWithTag(11) {
            UIView.animate(withDuration: 0.3) {
                view.alpha = 0
                view.frame = CGRect(x: 20, y: -100, width: UIScreen.main.bounds.width - 40, height: 100)
            } completion: { finished in
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: - Map View delegate methods.
extension ViewController: MKMapViewDelegate {

    /// MKMapViewDelegate method to render overlay.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.2) // Set the fill color with transparency
            circleRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.8) // Set the border color with transparency
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    /// MKMapViewDelegate method to handle the update of user location.
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setCenter(userLocation.coordinate, animated: true)
    }
}


//MARK: - Constants
extension ViewController {
    
    struct FileConstant {
        static let addGeofenceMessage = "Adjust the map below marker to set the geofence center location."
        static let circleRadius: CLLocationDistance = 200
    }
}

//MARK: - States
extension ViewController {
    
    enum NavigationItemState {
        case create
        case done
        case edit
    }
}
