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
	
	var linfo: LocationInfo!
	var lc: LocationController!

    override func viewDidLoad() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.DisplayLocation), name: Notification.Name("UpdateLocation"), object: nil)
		super.viewDidLoad()

		linfo = LocationInfo.sharedInstance
		lc = LocationController.sharedInstance
		lc.senderVC = self
		lc.LocationPermissions()

		locationButton.layer.cornerRadius = locationButton.bounds.size.width / 2
    }
	
	override func viewWillAppear(_ animated: Bool) {
		self.setmapType(type: MapTypeEnum(rawValue: UserDefaults.standard.integer(forKey: "MapType"))!)
		super.viewWillAppear(true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		lc.StopLocationUpdates(sender: self)
		super.viewWillDisappear(true)
	}

	func setmapType(type: MapTypeEnum) {
		switch type {
		case .satellite:
			mapView.mapType = .satellite

		case .hybrid:
			mapView.mapType = .hybrid

		case .map:
			fallthrough

		default:
			mapView.mapType = .standard
		}
	}
	
	//MARK: - IBActions
	
	@IBAction func GetCurrentLocation(_ sender: Any) {
		let _cLocationUpdates = UserDefaults.standard.bool(forKey: "ContiniousLocation")
		
		if !_cLocationUpdates {
			lc.GetCurrentLocation(sender: self)
		}
		else {
			if lc.isUpdating {
				lc.StopLocationUpdates(sender: self)
				locationButton?.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
			}
			else {
				lc.StartLocationUpdates(sender: self)
				locationButton?.tintColor = UIColor .green
			}
		}
	}
	
	@IBAction func GetLocationAtTouchPoint(_ sender: Any) {
		mapView.removeAnnotations((mapView?.annotations)!)
		
		let touchPoint = longPress?.location(in: mapView)
		linfo.ConvertTouchesToLocation(touchPoint: touchPoint!, sender: mapView!)
		
		Annotator.DisplayAnnotation(linfo.currentLocation!, userSelected: true, sender: mapView!)
	}

	//MARK: - Location Display

	@objc func DisplayLocation() {
		mapView.removeAnnotations((mapView?.annotations)!)
		
		RegionManager.DisplayRegion(locationRegion: linfo.currentLocation!, sender: mapView!)
		
		let _cLocationUpdates = UserDefaults.standard.bool(forKey: "ContiniousLocation")
		
		if !_cLocationUpdates {
			Annotator.DisplayAnnotation(linfo.currentLocation!, userSelected: false, sender: mapView!)
		}
	}
}
