//
//  mapController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

import UIKit
import MapKit

class mapController: UIViewController {
	
	@IBOutlet var locationButton: UIButton!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var longPress: UIGestureRecognizer!
	
	let linfo = LocationInfo.sharedInstance
	let lc = LocationController.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(UpdateMap), name: Notification.Name("UpdateLocation"), object: nil)
		locationButton?.layer.cornerRadius = (locationButton?.bounds.size.width)! / 2
    }
	
	override func viewWillAppear(_ animated: Bool) {
		let _mapType: Int = UserDefaults.standard.integer(forKey: "MapType")
		
		switch _mapType {
		case 0:
			mapView?.mapType = .standard
			
		case 1:
			mapView?.mapType = .satellite
			
		case 2:
			mapView?.mapType = .hybrid
			
		default: mapView?.mapType = .standard
		}
		
		super.viewWillAppear(true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		lc.StopLocationUpdates(sender: self)
		locationButton?.tintColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
		super.viewWillDisappear(true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
//MARK: IBActions
	
	@IBAction func GetLocation(_ sender: Any) {
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
	
	@IBAction func SetPointAtTouch(_ sender: Any) {
		mapView?.removeAnnotations((mapView?.annotations)!)
		let touchPoint = longPress?.location(in: mapView)
		linfo.ConvertTouchesToLocation(touchPoint: touchPoint!, sender: mapView!)
		
		Annotator.DisplayAnnotation(linfo.currentLocation!, userSelected: true, sender: mapView!)
	}
	
	func UpdateMap() {
		
	}
	
	func DisplayLocation() {
		mapView?.removeAnnotations((mapView?.annotations)!)
		
		RegionManager.DisplayRegion(locationRegion: linfo.currentLocation!, sender: mapView!)
		
		let _cLocationUpdates = UserDefaults.standard.bool(forKey: "ContiniousLocation")
		
		if !_cLocationUpdates {
			Annotator.DisplayAnnotation(linfo.currentLocation!, userSelected: false, sender: mapView!)
		}
	}
}
