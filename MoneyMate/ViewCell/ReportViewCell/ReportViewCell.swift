//
//  ReportViewCell.swift
//  MoneyMate
//
//  Created by Duong on 16/10/25.
//

import UIKit

class ReportViewCell: UITableViewCell {

    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var subTitleLable: UILabel!
    
    @IBOutlet weak var descriptionLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        viewContent.layer.cornerRadius = 10
        viewContent.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
