//
//  InfoMessageViewController.swift
//  FindMyFriends
//
//  Created by Susan Kohler on 3/6/15.
//  Copyright (c) 2015 Susan Kohler. All rights reserved.
//

import UIKit

class InfoMessageViewController: UIViewController {
    
    var infoMessageView:UITextView?
    var infoHTMLView:UIWebView?
    var message:InfoMessage!
    
     override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(red:0.875, green:0.88, blue:0.91, alpha:1)
        if message.messageName == "Introduction" {
            infoHTMLView = UIWebView(frame:view.bounds)
            let localfilePath = Bundle.main.url(forResource: "Introduction", withExtension:"htm")
            let myRequest = URLRequest(url: localfilePath!)
            infoHTMLView!.loadRequest(myRequest)
            self.view.addSubview(infoHTMLView!)
            
        } else {
            infoMessageView = UITextView(frame: view.bounds)
            infoMessageView!.frame.size = CGSize(width: self.view.frame.width * 0.85, height: self.view.frame.height * 0.75)
            infoMessageView!.center = self.view.center
            infoMessageView!.font = UIFont(name:"arial",size:20)
            infoMessageView!.text = message.messageContent
            infoMessageView!.isEditable = false
            infoMessageView!.textAlignment = NSTextAlignment.left
            self.view.addSubview(infoMessageView!)
        }
    }
    
    
}
