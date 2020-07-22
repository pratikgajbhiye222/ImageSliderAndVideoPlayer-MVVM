//
//  MediaDetailsModel.swift
//  ACADEZY
//
//  Created by pratik gajbhiye on 17/07/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import SDWebImage
class MediaDetailsModel{
    
    
//    var coach = [Coach]()
    var mediaDetails = [MediaDetails]()
    
   
    init?(data: Data) {
        do{
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ,
                let body = json["data"] as? [String: Any]
            {
                if let mediaDetails = body["feed"] as? [[String: Any]]{
                    self.mediaDetails = mediaDetails.map{ MediaDetails(json: $0)}
                }
            }
        }
        catch{
            print("Error deserializing JSON: \(error)")
            return nil
        }
    }
}


class MediaDetails: Encodable {
    var fullName : String?
    var academyName : String?
    var pictureUrl: String?
    var feedImage = [FeedImages]()
    var videoURL: String?
    var hashtag: String?
    var sessionName: String?
    var sessionDetails: String?
    init(json: [String: Any]) {
        self.fullName = json["fullName"] as? String
        self.academyName = json["academyName"] as? String
        self.pictureUrl = json["pictureUrl"] as? String
        self.videoURL = json["videoUrl"] as? String
        self.hashtag = json["hashtag"] as? String
        self.sessionName = json["sessionName"] as? String
        self.sessionDetails = json["sessionDetails"] as? String
        
        if let feedImages = json["feedImage"] as? [[String: Any]]{
            self.feedImage = feedImages.map{ FeedImages(json: $0)}
        }
    }
}

class FeedImages: Encodable {
    var images: String?
     init(json:[String: Any]) {
         self.images = json["images"] as? String
    }
}




