//
//  MediaDetailsTableViewCell.swift
//  ACADEZY
//
//  Created by pratik gajbhiye on 17/07/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import UIKit
import AVFoundation
import ImageSlideshow
import SDWebImage

class MediaDetailsTableViewCell: UITableViewCell , ASAutoPlayVideoLayerContainer{
    
    var imageDataUrl = [SDWebImageSource]()
    weak var delegate: ImageSlideshowDelegate?
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    @IBOutlet weak var fullNameOnFeed : UILabel!
    @IBOutlet weak var academyNameOnFeed : UILabel!
    @IBOutlet weak var pictureUrlOnFeed : UIImageView!
    //        @IBOutlet weak var feedImageOnFeed : UIImageView!
    @IBOutlet weak var hashtagOnFeed : UILabel!
    @IBOutlet weak var sessionNameOnFeed : UILabel!
    @IBOutlet weak var sessionDetailsOnFeed : UILabel!
    
    var playerController: ASVideoPlayerController? = nil
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    var pageIndex: Int = 0
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
            videoLayer.frame = self.frame
            videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoLayer.videoGravity = .resizeAspectFill
            videoLayer.frame = slideshow.bounds
            
            
        }
    }
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
            if let pictureUrl = item.pictureUrl {
                pictureUrlOnFeed?.image = UIImage(named: pictureUrl)
            }
            //If there is video , set imageslider nil
            if item.videoURL != nil {
                if let videoLayerURL = item.videoURL {
                    self.videoURL = videoLayerURL
                    self.configureCell(imageUrl: nil, videoUrl: videoLayerURL)
                    print("video is \(videoLayerURL)")
                    slideshow.pageIndicator?.numberOfPages = 0
                }
            }
                //If there is images , set video nil
            else {
                let itemImages = item.feedImage
                print(itemImages)
                if itemImages.isEmpty == false {
                    for url in itemImages {
                        
                        let image = SDWebImageSource(urlString: url.images ?? "")
                        if let SDURL = image {
                            imageDataUrl.append(SDURL)
                            
                        }
                        slideshow.setImageInputs(self.imageDataUrl)
                        self.configureCell(imageUrl: slideshow, videoUrl: nil)
                        
                    }
                     
                }
            }

        }
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SDImageCache.shared.config.maxMemoryCost = 15 * 1024 * 1024
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        videoLayer.frame = slideshow.bounds
        slideshow.layer.addSublayer(videoLayer)
        selectionStyle = .none
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.preload = .fixed(offset: 5)
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource
        
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(MediaDetailsTableViewCell.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
    }
    

    
    @objc func didTap(){
        print("did Tap")
        ASVideoPlayerController.sharedVideoPlayer.shouldPlay.toggle()
    }
    
    func configureCell(imageUrl: ImageSlideshow?,
                       videoUrl: String?) {
        guard let sdd = imageUrl else { return}
        self.slideshow = sdd
        self.videoURL = videoUrl
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
    override func prepareForReuse() {
        super.prepareForReuse()
        slideshow.zoomEnabled = true
        slideshow.currentPageChanged = nil
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let _: CGFloat = 20
        let width: CGFloat = slideshow.bounds.width
        let height: CGFloat = slideshow.bounds.height
        videoLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
    }
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(slideshow.frame, from: slideshow)
        guard let videoFrame = videoFrameInParentSuperView,
            let superViewFrame = superview?.frame else {
                return 0
        }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
    deinit {
            print("imgslideshow deinit")
        if item?.feedImage.isEmpty == false {
                imageDataUrl.removeAll()
            }
            slideshow = nil
        }
        
    }


extension MediaDetailsTableViewCell: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}



