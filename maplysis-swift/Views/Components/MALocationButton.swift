//
//  MALocationButton.swift
//  maplysis-swift
//
//  Created by Perikles Maravelakis on 5/1/24.
//  Copyright © 2024 cloudfields. All rights reserved.
//

import UIKit

class MALocationButton: UIButton {

    enum LocationState {
        case standard, continuousOFF, continuousON
    }
    
    /*
     Location Continuous: Filled Location Icon with SystemTeal when On and SystemPurple when Off
     Non-Continuous: Outlined Location Icon with SystemPurple Background
     */
    
    func setState(state: LocationState) {
        switch state {
        case .standard: 
            self.tintColor = .systemPurple
            self.setImage(UIImage(systemName: "location"), for: .normal)
        
        case .continuousOFF: 
            self.tintColor = .systemPurple
            self.setImage(UIImage(systemName: "location.fill"), for: .normal)
            
        case .continuousON: 
            self.tintColor = .systemTeal
            self.setImage(UIImage(systemName: "location.fill"), for: .normal)
        }
    }
}
