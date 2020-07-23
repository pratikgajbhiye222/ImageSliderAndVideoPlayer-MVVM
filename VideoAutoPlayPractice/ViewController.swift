//
//  ViewController.swift
//  VideoAutoPlayPractice
//
//  Created by pratik gajbhiye on 17/07/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import UIKit
import ImageSlideshow
class MediaViewController: UIViewController {
 
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
        

        tableView.reloadData()
        
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

extension MediaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
      
        
     }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
}

//extension MediaViewController : MediaDetailsTableViewCellDelegate {
//    func didTappedOnBookMark(title: String) {
//      //  let vc : MediaViewController? = MediaViewController()
//        print("kuch to h")
//        let alertMessagea = "BookMark Added"
//        let message = "\(title) added to bookmark"
//        
//        let alert = UIAlertController(title: alertMessagea, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//    
//    
//}
//

