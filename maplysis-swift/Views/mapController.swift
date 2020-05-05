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

class mapController: UIViewController {
	
	@IBOutlet var locationButton: UIButton!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var longPress: UIGestureRecognizer!

    override func viewDidLoad() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.DisplayLocation), name: Notification.Name("UpdateLocation"), object: nil)
		super.viewDidLoad()

		LocationController.sharedInstance.senderVC = self
		LocationController.sharedInstance.locationPermissions()

		locationButton.layer.cornerRadius = locationButton.bounds.size.width / 2
    }
	
	override func viewWillAppear(_ animated: Bool) {
        self.setmapType(type: AppPreferences.shared.mapType)
		super.viewWillAppear(true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		LocationController.sharedInstance.stopLocationUpdates(sender: self)
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
			LocationController.sharedInstance.getCurrentLocation(sender: self)
		}
		else {
			if LocationController.sharedInstance.isUpdating {
				LocationController.sharedInstance.stopLocationUpdates(sender: self)
				locationButton?.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
			}
			else {
				LocationController.sharedInstance.startLocationUpdates(sender: self)
				locationButton?.tintColor = UIColor .green
			}
		}
	}
	
	@IBAction func GetLocationAtTouchPoint(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            mapView.removeAnnotations((mapView?.annotations)!)
            
            let touchPoint = longPress?.location(in: mapView)
            LocationInfo.sharedInstance.touchToLocation(touchPoint: touchPoint!, sender: mapView!)
            
            Annotator.displayAnnotation(LocationInfo.sharedInstance.currentLocation!, userSelected: true, sender: mapView!)
        }
	}

	//MARK: - Location Display

	@objc func DisplayLocation() {
		mapView.removeAnnotations((mapView?.annotations)!)
		
		RegionManager.getRegion(locationRegion: LocationInfo.sharedInstance.currentLocation!, sender: mapView!)
		
		if !AppPreferences.shared.continiousUpdates {
			Annotator.displayAnnotation(LocationInfo.sharedInstance.currentLocation!, userSelected: false, sender: mapView!)
		}
	}
}
