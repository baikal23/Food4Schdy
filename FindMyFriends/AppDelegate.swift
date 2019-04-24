//
//  AppDelegate.swift
//  FindMyFriends
//
//  Created by Susan Kohler on 12/29/14.
//  Copyright (c) 2014 Susan Kohler. All rights reserved.
//
//  This version is like TreasureHunt  It finds friends and plots their locations and gives info about them
//  Now need to get the info from the Contacts Address Book and also my location
//  Now have code to get first and last names from address book - must check to see if they exist or it crashes
//  Also get addresses and phone numbers
//  can also use fetchLocation() to find lat and longitude of an  address - note response from google comes back as a JSON thing  may be delay
//  it takes  time to get the info into contacts array, and the code does not wait for completion - ARGH
//  need to learn how to wait for completion - for now, use a button
//  added more stuff - fetchLocation gets the location BUT after a delay - must figure out completion blocks/closures for it
//  okay, finally got array friendsWithLoc to store lat and lng for all valid contacts
// app works well -
// next must add activity indicator and think about storing information more permanently
// check functionality of filehelper function
// tried to build in archiving - must test it - array of newFriends - names are messy, but should be ok for testing
// archiving works - and only find myLocation when needed to update map 
// next put in different groups of contacts  and activity indicator
// I can get the info about the group name and the members in each group - each group is a ContactGroup in the array "groups"
// Yahoo - it works!
// Put in Company name and contact date  - 
// Contact Date is updated automatically when text or phone attempt
// cleaned up phone string - would be nice to know how to clean several characters at once
// stil to do - activity wheel and group management
// problem - delete data before updating contacts, so last contact date info is lost.  Need separate array of who and date
// made dateDictionary and archived the data - now myust pull it out when update
// think that the contact date stuff all works now - still need activity wheel
// IMPORTANT - just figured out that functions with completion blocks exit from the block - so beware of nesting
// fixed things so works with no phone number
// still need activity indicator - and test for various address success
// added activity indicator but it does not stop - fixed!  needs to be on main queue
// search for "fix this" - google just needs city + state or zip to get successful address - done but must check
// FINALLY got InfoTableViewController to make array infoMessageArray loaded form the InfoMessage.plist  this was awful
// it all works - it would be nice to reduce the size of the infoMessageView and center it - DONE!
// March 11 - all works including iPad  would be nice to resize images larger on iPad
// need to figure out sort for infoMesages - Done - use "sorted" function
// remember to think about target ios when sending off to apple
// limited to Portrait by editing info.plist
// all done - use LaunchScreen.xib for launch images and <= for images and pin to edges for best performance
// Got rid of Google - using CLLocation to forward geolocate - seems to work well
// Put in error checking for Geocoding
// March 30 - bug fixes
// app crashes on return from Maps app on my iPad but not my phone  can fix in info.plist by saying NO tor running in bkgd
// April 9 - think crashes at Apple due to probs with ABAddressBookRequestAccessWithCompletion so dispatched it on main queue
// see QuickContacts sample project to see parallel useage
// updated to swift 1.2  Think crashes will be fixed by fixed compiler by Apple
// see http://stackoverflow.com/questions/28455737/swift-crash-extracting-record-value-from-address-book
// May 4 - took care of case of zero contacts.  That would crash it too
// 
// IMPORTANT - just figured out that functions with completion blocks exit from the block - so beware of nesting AGAIN!!
// used new code for address book and broke up functions - seems cleaner and seems to work

// check for web connectivity??
// button state stuff is not elegant
// get good tiny images for each category - rest is good except for cryptic warning
// fixed a lot of warnings
// need splash screen and updated instructions
// enabled summer button
// resized range on map
// updated to new database
// Dec. 21 2015 - updated info pages and display names on buttons
// using showsUserLocation - addMeToMap doesn't add me now but does set map size
// using archived database now
// can go to web page - 
// added favorites capability - can add or remove
// still need to figure out when and where to updateDatabase and loadDatabase - now it updates when app is started
// adjusted scaling to include my current location - or 4000 meters if i am close
// added search functionality and checking for version number 
// think it is done except for updated icon - done
// updated to Universal app 2/5/16
// set UIRequiresFullScreen to YES in info.plist to avoid compile requirements for landscape
// July 1 2016 converted to HTTPS
// trying to get it to work in Swift3 - data not getting saved (or read back) tried using UserDefaults  - didn't help - but "Person" test works
// got it working - problem was with encoding Doubles -
// updated the website - Aug 2018
// making git repo April 2019 - and it is Swift5

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

