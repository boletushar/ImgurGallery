//
//  ImgurModel.swift
//  ImgurGallery
//
//  Created by Tushar on 19/8/18.
//  Copyright © 2018 bole.tushar.imgurapp. All rights reserved.
//

import Foundation


struct ImgurModel {
    
    let title : String?
    let datetime : Date
    let imageCount : Int
    var imageURL : String?
    
    // This varibale will be true if the sum of points, score and topic_id is even
    var isSumEven : Bool
    
    init(_ dictionary: [String: Any]) {
        
        self.title = dictionary["title"] as? String ?? nil
        let date = dictionary["datetime"] as! TimeInterval
        self.datetime = Date(timeIntervalSince1970: date)
        
        let isAlbum = dictionary["is_album"] as? Bool ?? false
        
        if isAlbum {
            self.imageCount = dictionary["images_count"] as! Int
        
            self.imageURL = nil
            if let images = dictionary["images"] as? [[String: Any]] {
                for image in images {
                    
                    if let link = image["link"] as? String, link.count > 0 {
                        self.imageURL = link
                        break
                    }
                }
            }
        } else {
            self.imageCount = 1
            self.imageURL = dictionary["link"] as? String ?? nil
        }
        
        self.isSumEven = false
        let points = dictionary["points"] as? Int ?? 0
        let score = dictionary["score"] as? Int ?? 0
        let topicID = dictionary["topic_id"] as? Int ?? 0
        
        if ((points + score + topicID) % 2 == 0) {
            self.isSumEven = true
        }
    }
}
