//
//  PostCommentData.swift
//  Instagram
//
//  Created by 松原保子 on 2018/02/15.
//  Copyright © 2018年 Yasuko.Matsubara. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class PostCommentData: NSObject {
    var id: String?
    var comments: String?
    var commentName: String?
    var date: NSDate?
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        self.commentName = valueDictionary["commentName"] as? String
        
        self.comments = valueDictionary["comments"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    }
}
