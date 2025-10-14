//
//  ProfileTableViewCell.swift
//  MoneyMate
//
//  Created by Duong on 3/10/25.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var subTitleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.tintColor = .white
        //img.backgroundColor = .systemGreen
        img.layer.cornerRadius = 12
        img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
