//
//  PostData.swift
//  Instagram
//
//  Created by 松原保子 on 2018/02/06.
//  Copyright © 2018年 Yasuko.Matsubara. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: NSDate?
    var likes: [String] = []
    var isLiked: Bool = false
    var setcomments: [String] = []
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
        
        self.name = valueDictionary["name"] as? String
        
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
        
        self.setcomments = []
        if let commentsData = valueDictionary["comments"] as? [String: Any] {
            for key in commentsData.keys.sorted() {
                guard let data = commentsData[key] as? [String: String] else { return }
                let comment = "\(data["commentName"]!) : \(data["comments"]!)"
                self.setcomments.append(comment)
            }
        }

    }
}
