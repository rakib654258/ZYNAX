//
//  SliderCollectionCell.swift
//  ZynaxAssignment
//
//  Created by user on 18/11/20.
//

import UIKit

class SliderCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageLbl: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageLbl.layer.cornerRadius = 10
    }

}
