//
//  Friend.swift
//  MoonChat
//
//  Created by Fujimoto Akira on 2020/08/27.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import Foundation
import UIKit

struct Friend {
    
    var name: String
    var icon: UIImage
    
    init(_ name: String) {
        self.name = name
        self.icon = UIImage()
    }
}
