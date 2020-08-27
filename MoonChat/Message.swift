//
//  Message.swift
//  MoonChat
//
//  Created by Fujimoto Akira on 2020/08/26.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import Foundation

struct Message {
    let message: String
    let date: Date
    
    init(_ message: String, dateUnix: TimeInterval) {
        self.message = message
        self.date = Date(timeIntervalSince1970: dateUnix)
    }
    
    func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}
