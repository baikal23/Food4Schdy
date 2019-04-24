//
//  InfoMessage.swift
//  FindMyFriends
//
//  Created by Susan Kohler on 3/6/15.
//  Copyright (c) 2015 Susan Kohler. All rights reserved.
//

import UIKit

class InfoMessage {
    var messageName:String
    var messageContent:String
    var rank:Int
    
    init(aDictionary: Dictionary<String,AnyObject>) {
        self.messageName = aDictionary["name"] as! String
        self.messageContent = aDictionary["message"] as! String
        self.rank = aDictionary["rank"] as! Int
        return
    }
}
