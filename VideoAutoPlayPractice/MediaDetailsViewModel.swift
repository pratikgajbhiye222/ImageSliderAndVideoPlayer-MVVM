//
//  MediaDetailsViewModel.swift
//  ACADEZY
//
//  Created by pratik gajbhiye on 17/07/20.
//  Copyright © 2020 Mobile. All rights reserved.
//

import Foundation
import UIKit

enum MediaDetailsViewModelType{
    case mediaList
}

protocol MediaDetailsViewModelItems {
    var type: MediaDetailsViewModelType { get }
    var rowCount: Int { get }
}

extension MediaDetailsViewModelItems {
    var rowCount: Int {
        return 1
    }
}

class MediaDetailsViewModelFeedItem: MediaDetailsViewModelItems {
    var type: MediaDetailsViewModelType{
        return .mediaList
    }
    var rowCount: Int {
        return mediaDetailsList.count
    }
    var mediaDetailsList: [MediaDetails]
    init(mediaDetailsList: [MediaDetails] ) {
        self.mediaDetailsList = mediaDetailsList
    }
}

class MediaDetailsViewModel : NSObject{
    var items = [MediaDetailsViewModelItems]()
    //MARK: - Initilization
    override init() {
        super.init()
        guard let data = dataFromFile("FeedServerData"),
            let mediaDetailslist = MediaDetailsModel(data: data) else {
                return
        }

        let media =  mediaDetailslist.mediaDetails
        if !media.isEmpty {
            let MediaDetailsListItem = MediaDetailsViewModelFeedItem(mediaDetailsList: media)
            items.append(MediaDetailsListItem)
        }
    }
}


extension MediaDetailsViewModel: UITableViewDataSource ,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items[section].rowCount)
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .mediaList:
            if let item = item as? MediaDetailsViewModelFeedItem ,let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailsTableViewCell.identifier, for: indexPath) as? MediaDetailsTableViewCell {
                cell.item = item.mediaDetailsList[indexPath.row]
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
     }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
}

public func dataFromFile(_ filename: String) -> Data? {
    @objc class TestClass: NSObject { }
    let bundle = Bundle(for: TestClass.self)
    if let path = bundle.path(forResource: filename, ofType: "json") {
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    }
    return nil
    
}
