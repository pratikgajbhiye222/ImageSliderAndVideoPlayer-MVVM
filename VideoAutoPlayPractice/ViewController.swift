//
//  ViewController.swift
//  VideoAutoPlayPractice
//
//  Created by pratik gajbhiye on 17/07/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import UIKit
import ImageSlideshow
class MediaViewController: UIViewController , UITableViewDelegate{
 
    let viewModel = MediaDetailsViewModel()
  static  let sharedInstance = MediaViewController()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.appEnteredFromBackground),
        name: UIApplication.willEnterForegroundNotification, object: nil)
        tableView.delegate = self
        tableView.dataSource = viewModel
    
        tableView.register(MediaDetailsTableViewCell.nib, forCellReuseIdentifier: MediaDetailsTableViewCell.identifier)
        navigationItem.title = "Acadezy"
        tableView.separatorStyle = .none
        tableView.isPagingEnabled = false
        

   
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
  


    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
        
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
}

extension MediaViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           pausePlayeVideos()
       }
       
       func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
           if !decelerate {
               pausePlayeVideos()
           }
       }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard var scrollingToIP = tableView.indexPathForRow(at: CGPoint(x: 0, y: targetContentOffset.pointee.y)) else {
            return
        }
        var scrollingToRect = tableView.rectForRow(at: scrollingToIP)
        let roundingRow = Int(((targetContentOffset.pointee.y - scrollingToRect.origin.y) / scrollingToRect.size.height).rounded())
        scrollingToIP.row += roundingRow
        scrollingToRect = tableView.rectForRow(at: scrollingToIP)
        targetContentOffset.pointee.y = scrollingToRect.origin.y
        pausePlayeVideoAfterDisappear()
    }
    
    
       func pausePlayeVideos()  {
           ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
       }
    func pausePlayeVideoAfterDisappear()  {
        ASVideoPlayerController.sharedVideoPlayer.removePlayer(tableView: tableView)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height
    }
    
    
    
       
}
