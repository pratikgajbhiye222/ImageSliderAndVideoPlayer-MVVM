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


extension MediaDetailsViewModel: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(items[section].rowCount)
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let vc : MediaViewController = MediaViewController()
        let item = items[indexPath.section]
        switch item.type {
        case .mediaList:
            if let item = item as? MediaDetailsViewModelFeedItem ,let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailsTableViewCell.identifier, for: indexPath) as? MediaDetailsTableViewCell {
                cell.item = item.mediaDetailsList[indexPath.row]
                cell.imageDataUrl.removeAll()
                cell.bookMarkButton.tag = indexPath.row
                cell.tapBlock = {
                    print(indexPath.row)
                    self.didTappedOnBookMarkButton(cell.bookMarkButton, tag: cell.bookMarkButton.tag)
                }
                let index = IndexPath(item: 0, section: 0)
                tableView.reloadRows(at: [index], with: .automatic)
                
         //       cell.cellDelegate = vc.self
               
                return cell
            }
        }
        return UITableViewCell()
    }
    @objc func didTappedOnBookMarkButton(_ button: UIButton , tag : UIButton.tag){
        tag(row: )
    
        if button.isSelected {
            button.tintColor = UIColor.blue
        } else {
            button.tintColor = UIColor.red
        }
        button.isSelected.toggle()
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

