//
//  mapController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import UIKit
import MapKit

protocol MapDelegate {
	func displayLocation()
	func locationErrorWithDeviceService(enabled: Bool)
}

class mapVC: UIViewController {
	
	@IBOutlet weak var locationButton: UIButton!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var longPress: UIGestureRecognizer!
	
	let locController = LocationController()

    override func viewDidLoad() {
		super.viewDidLoad()

		locController.mapDelegate = self
		locController.locationPermissions()

		locationButton.layer.cornerRadius = locationButton.bounds.size.width / 2
    }
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setmapType(type: AppPreferences.shared.mapType)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		locController.stopLocationUpdates()
		super.viewWillDisappear(true)
	}

	func setmapType(type: MapType) {
		switch type {
		case .satellite:
			mapView.mapType = .satellite

		case .hybrid:
			mapView.mapType = .hybrid

		case .map:
			mapView.mapType = .standard
		}
	}
	
	//MARK: - IBActions
	
	@IBAction func GetCurrentLocation(_ sender: Any) {
		if !AppPreferences.shared.continiousUpdates {
			locController.getCurrentLocation()
		}
		else {
			if locController.isUpdating {
				locController.stopLocationUpdates()
				locationButton?.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
			}
			else {
				locController.startLocationUpdates()
				locationButton?.tintColor = UIColor .green
			}
		}
	}
	
	@IBAction func GetLocationAtTouchPoint(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            mapView.removeAnnotations((mapView?.annotations)!)
            
            let touchPoint = longPress?.location(in: mapView)
            Location.shared.touchToLocation(touchPoint: touchPoint!, sender: mapView!)
            
            Annotator.displayAnnotation(Location.shared.currentLocation!, userSelected: true, sender: mapView!)
        }
	}
}

extension mapVC: MapDelegate {
	
	//MARK: - Location Display
	
	func displayLocation() {
		mapView.removeAnnotations((mapView?.annotations)!)
		
		RegionManager.getRegion(locationRegion: Location.shared.currentLocation!, sender: mapView!)
		
		if !AppPreferences.shared.continiousUpdates {
			Annotator.displayAnnotation(Location.shared.currentLocation!, userSelected: false, sender: mapView!)
		}
	}
	
	//MARK: - Display Error Alert
	func locationErrorWithDeviceService(enabled: Bool) {
		var title: String?
		var message: String?
		
		if enabled {
			title = "Location permissions"
			message = "You have denied location services for this app."
		}
		else {
			title = "Location services"
			message = "You have disabled or restricted location services on your device."
		}
		
		let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
		let okbutton = UIAlertAction.init(title: "OK", style: .default, handler: nil)
		alert.addAction(okbutton)
		
		self.present(alert, animated: true, completion:nil)
	}
}
