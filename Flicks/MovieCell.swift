//
//  MovieCell.swift
//  Flicks
//
//  Created by Difan Chen on 1/20/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
