//
//  CategoryViewCell.swift
//  MoneyMate
//
//  Created by Duong on 24/10/25.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    @IBOutlet weak var viiewContent: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viiewContent.layer.cornerRadius = 5
        viiewContent.layer.masksToBounds = true
    }

}
