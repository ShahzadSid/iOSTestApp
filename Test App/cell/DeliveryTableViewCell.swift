//
//  DeliveryTableViewCell.swift
//  Test App
//
//  Created by Muhammad Shahzad on 9/21/18.
//  Copyright © 2018 Muhammad Shahzad. All rights reserved.
//

import UIKit
import SDWebImage

class DeliveryTableViewCell: UITableViewCell {

    var delivery : Delivery? {
        didSet {
            deliveryDescriptionLabel.text = (delivery?.descriptionField)!
            deliveryLocationLabel.text = delivery?.location?.address
            deliveryThumbnailImageView.sd_setImage(with: URL(string: (delivery?.imageUrl!)!))
        }
    }
    
    private let deliveryDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let deliveryLocationLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let deliveryThumbnailImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(deliveryLocationLabel)
        addSubview(deliveryDescriptionLabel)
        addSubview(deliveryThumbnailImageView)
        
        deliveryThumbnailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 75, height: 0, enableInsets: false)
        
        deliveryDescriptionLabel.anchor(top: topAnchor, left: deliveryThumbnailImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: frame.size.width-10, height: 0, enableInsets: false)
        
        deliveryLocationLabel.anchor(top: deliveryDescriptionLabel.bottomAnchor, left: deliveryThumbnailImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 0, width: frame.size.width-10, height: 0, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
