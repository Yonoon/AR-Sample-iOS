//
//  ApplianceItemCell.swift
//  ARFoodFinal
//
//  Created by 박용훈 on 23/09/2019.
//  Copyright © 2019 Koushan Korouei. All rights reserved.
//

import UIKit

class ApplianceItemCell: UICollectionViewCell {

    @IBOutlet var btnDetails: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var delegte: CollectionViewCellDelegte? = nil
    var index: Int!
    var category: String!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnDetails.layer.cornerRadius = 10
        index = 0

    }

    func configure(_ text: String) {
        label.text = text
    }

    func configure(_ appliance: Appliance) {
        let modelTxt = appliance.model
        label.text = modelTxt
        
        category = appliance.category
        imageView.image = UIImage(named: "\(modelTxt).png")
    }

    @IBAction func showDetails(_ sender: Any) {
        if let del = self.delegte {
            del.collectionViewCellDelegte(category: category, didClickButtonAt: index)
        }
    }
}
