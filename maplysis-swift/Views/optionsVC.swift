//
//  optionsController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//  Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)
//  https://creativecommons.org/licenses/by/4.0/
//

import UIKit

class optionsVC: UITableViewController {
	
	@IBOutlet weak var contLocSwitch: UISwitch!
	@IBOutlet weak var mZoomProgress: UISlider!
	@IBOutlet weak var mapTypeSegm: UISegmentedControl!
	@IBOutlet weak var geocoderSegm: UISegmentedControl!
    @IBOutlet weak var googleNote: UILabel!
    
    var continuousUpdates: ((Bool) -> Void)?
    var mapTypeUpdate: (() -> Void)?
    var locationUpdate: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
		
        contLocSwitch.isOn = AppPreferences.shared.continuousUpdates
        mZoomProgress.value = Float(AppPreferences.shared.mapZoom)
        mapTypeSegm.selectedSegmentIndex = AppPreferences.shared.mapType.rawValue
        geocoderSegm.selectedSegmentIndex = AppPreferences.shared.geocoder.rawValue
    }
	
	//MARK: - IBActions
	
	@IBAction func closeAction() {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func setContinuousUpdating() {
        AppPreferences.shared.continuousUpdates = contLocSwitch.isOn
        continuousUpdates?(contLocSwitch.isOn)
	}
	
	@IBAction func setMapZoomLevel() {
        AppPreferences.shared.mapZoom = Double(mZoomProgress.value)
        locationUpdate?()
	}
	
	@IBAction func setMapType() {
        AppPreferences.shared.mapType = MapType(rawValue: mapTypeSegm.selectedSegmentIndex)!
        mapTypeUpdate?()
	}
	
	@IBAction func setGeocoder() {
        AppPreferences.shared.geocoder = GeocoderService(rawValue: geocoderSegm.selectedSegmentIndex)!
	}
}
