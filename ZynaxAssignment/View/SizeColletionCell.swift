//
//  SizeColletionCell.swift
//  ZynaxAssignment
//
//  Created by user on 18/11/20.
//

import UIKit

class SizeColletionCell: UICollectionViewCell {

    @IBOutlet weak var sizeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sizeLbl.layer.borderWidth = 0.5
        sizeLbl.layer.borderColor = UIColor.systemGray.cgColor
        sizeLbl.layer.cornerRadius = 4
    }

}
