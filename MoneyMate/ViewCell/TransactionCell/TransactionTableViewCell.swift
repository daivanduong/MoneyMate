//
//  TransactionTableViewCell.swift
//  MoneyMate
//
//  Created by Duong on 10/10/25.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var subTitleLable: UILabel!
    
    @IBOutlet weak var amountLable: UILabel!
    
    @IBOutlet weak var viewContent: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        viewContent.layer.cornerRadius = 5
        viewContent.layer.masksToBounds = true
      
    }
    
}
