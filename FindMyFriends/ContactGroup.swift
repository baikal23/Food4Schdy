//
//  ContactGroup.swift
//  FindMyFriends
//
//  Created by Susan Kohler on 2/14/15.
//  Copyright (c) 2015 Susan Kohler. All rights reserved.
//

import Foundation

class ContactGroup: NSObject, NSCoding {
    var groupName: String
    var memberArray:[String]
    
    init(groupName:String){
        self.groupName = groupName
        self.memberArray = []
        super.init()
    }
    
    required init(coder decoder: NSCoder) {
        self.groupName = decoder.decodeObject(forKey: "groupName")! as! String
        self.memberArray = decoder.decodeObject(forKey: "memberArray")!as! Array <String>
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.groupName, forKey: "groupName")
        coder.encode(self.memberArray, forKey:"memberArray")
    }
    
}
