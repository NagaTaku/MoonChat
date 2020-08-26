//
//  MessageTableViewCell.swift
//  MoonChat
//
//  Created by Nagase Takuya on 2020/08/26.
//  Copyright © 2020 Nagase Takuya. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
