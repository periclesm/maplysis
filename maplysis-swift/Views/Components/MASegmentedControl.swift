//
//  MASegmentedControl.swift
//  maplysis-swift
//
//  Created by Perikles Maravelakis on 5/1/24.
//  Copyright © 2024 cloudfields. All rights reserved.
//

import UIKit

class MASegmentedControl: UISegmentedControl {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
}
