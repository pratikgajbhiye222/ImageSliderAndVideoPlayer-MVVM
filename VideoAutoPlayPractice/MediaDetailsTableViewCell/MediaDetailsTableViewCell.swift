//
//  MediaDetailsTableViewCell.swift
//  ACADEZY
//
//  Created by pratik gajbhiye on 17/07/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import UIKit

class MediaDetailsTableViewCell: UITableViewCell {
        @IBOutlet weak var fullNameOnFeed : UILabel!
        @IBOutlet weak var academyNameOnFeed : UILabel!
        @IBOutlet weak var pictureUrlOnFeed : UIImageView!
        @IBOutlet weak var feedImageOnFeed : UIImageView!
        @IBOutlet weak var hashtagOnFeed : UILabel!
        @IBOutlet weak var sessionNameOnFeed : UILabel!
        @IBOutlet weak var sessionDetailsOnFeed : UILabel!
        var item: MediaDetails? {
            didSet{
                guard let item = item  else {
                    return
                }
                if let fullNameOnFeed = fullNameOnFeed {
                    fullNameOnFeed.text = item.fullName
                }
                if let academyNameOnFeed = academyNameOnFeed {
                    academyNameOnFeed.text = item.academyName
                }
                if let hashtagOnFeed = hashtagOnFeed {
                    hashtagOnFeed.text = item.hashtag
                }
                if let sessionNameOnFeed = sessionNameOnFeed {
                    sessionNameOnFeed.text = item.sessionName
                }
                if let sessionDetailsOnFeed = sessionDetailsOnFeed {
                    sessionDetailsOnFeed.text = item.sessionDetails
                }
                if let feedImage = item.feedImage {
                    feedImageOnFeed?.image = UIImage(named: feedImage)
                }
                if let pictureUrl = item.pictureUrl {
                    pictureUrlOnFeed?.image = UIImage(named: pictureUrl)
                }
            }
        }
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        static var nib:UINib {
            return UINib(nibName: identifier, bundle: nil)
        }
       static var identifier: String {
            return String(describing: self)
        }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
}
