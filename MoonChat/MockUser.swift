//
//  MockUser.swift
//  MoonChat
//
//  Created by Fujimoto Akira on 2020/08/27.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import Foundation
import MessageKit

struct MockUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
