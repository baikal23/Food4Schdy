//
//  Filehelpers.swift
//  FindMyFriends
//
//  Created by Susan Kohler on 1/22/15.
//  Copyright (c) 2015 Susan Kohler. All rights reserved.
//

import Foundation

class Filehelpers: NSObject {
    
    class func pathInUserDocumentDirectory(_ filename:String) -> String {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] 

        let userDirectory = documentsPath + "/user"
        var finalPath:String
        
        let fileManager = FileManager.default
        
        
        if (fileManager.fileExists(atPath: userDirectory)) {
            
            finalPath = userDirectory + ("/" + "\(filename)")
        } else {
            
            do {
                try fileManager.createDirectory(atPath: userDirectory, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
          finalPath = userDirectory + ("/" + "\(filename)")
            
        }
        
        return finalPath
        
        
    }
}
