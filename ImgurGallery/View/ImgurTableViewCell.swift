//
//  ImgurTableViewCell.swift
//  ImgurGallery
//
//  Created by Tushar on 20/8/18.
//  Copyright © 2018 bole.tushar.imgurapp. All rights reserved.
//

import UIKit
import SDWebImage

class ImgurTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var imgurImageView: FLAnimatedImageView!
    
    var url : URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(data: ImgurModel) {
        
        self.nameLabel.text = data.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy h:mm a"
        self.dateLabel.text = formatter.string(from: data.datetime)
        self.imageCountLabel.text = "Image count \(data.imageCount)"
        
        if let url = URL(string: data.imageURL!) {
            
            self.url = url
            self.imgurImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "no-icon"), options: SDWebImageOptions(rawValue: 0)) { (image, error, cache, url) in
                
                let urlStr = url?.absoluteString
                let expectedStr = self.url?.absoluteString
                if (image != nil) && urlStr!.elementsEqual(expectedStr!) {
                    DispatchQueue.main.async {
                        self.imgurImageView.image = image
                    }
                }
            }
        }
    }
}
