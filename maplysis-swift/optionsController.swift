//
//  optionsController.swift
//  maplysis-swift
//
//  Created by Pericles Maravelakis on 02/07/2017.
//	periclesm@cloudfields.net
//	Licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
//	https://creativecommons.org/licenses/by-sa/4.0/
//

import UIKit

class optionsController: UITableViewController {
	
	@IBOutlet var contLocSwitch: UISwitch!
	@IBOutlet var mZoomProgress: UISlider!
	@IBOutlet var mapTypeSegm: UISegmentedControl!
	@IBOutlet var geocoderSegm: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
		
		contLocSwitch?.isOn = UserDefaults.standard.bool(forKey: "ContiniousLocation")
		mZoomProgress?.value = UserDefaults.standard.float(forKey: "MapZoomLevel")
		mapTypeSegm?.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "MapType")
		geocoderSegm?.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "Geocoder")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	//MARK: - IBActions
	
	@IBAction func CloseAction(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func SetContiniousUpdating(_ sender: Any) {
		UserDefaults.standard.set(contLocSwitch?.isOn, forKey: "ContiniousLocation")
		UserDefaults.standard.synchronize()
	}
	
	@IBAction func SetMapZoomLevel(_ sender: Any) {
		UserDefaults.standard.set(mZoomProgress?.value, forKey: "MapZoomLevel")
		UserDefaults.standard.synchronize()
	}
	
	@IBAction func SetMapType(_ sender: Any) {
		UserDefaults.standard.set(mapTypeSegm?.selectedSegmentIndex, forKey: "MapType")
		UserDefaults.standard.synchronize()
	}
	
	@IBAction func SetGeocoder(_ sender: Any) {
		UserDefaults.standard.set(geocoderSegm?.selectedSegmentIndex, forKey: "Geocoder")
		UserDefaults.standard.synchronize()
	}
	

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
}
