//
//  FoodSource.swift
//  ContactMap
//
//  Created by Susan Kohler on 10/28/15.
//  Copyright © 2015 Susan Kohler. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

@objc protocol Alertable {
    
    @available(iOS 8.0, *)
    func alert() -> UIAlertController
    
}

class FoodSource: NSObject, NSCoding {
    var cat: String
    var lat:Double
    var lng:Double
    var location:GeoLocation
    var favorite:Bool = false
    var org: String?
    var street: String?
    var city: String?
    var zip: String?
    var addressString: String?
    var phone:String?
    var times: String?
    var notes: String?
    var web: String?
    var distance: String?
    
    
    init(cat: String, lat: Double, lng: Double) {
        self.cat = cat
        self.lat = lat
        self.lng = lng
        self.location = GeoLocation(lat: lat, lng: lng)
    }
    
    
    // note do not archive the distance
    required init?(coder: NSCoder) {
        self.cat = coder.decodeObject(forKey: "cat")! as! String
        self.lat = coder.decodeDouble(forKey: "lat")
        self.lng = coder.decodeDouble(forKey: "lng")
        self.org = coder.decodeObject(forKey: "org") as? String
        self.street = coder.decodeObject(forKey: "street") as? String
        self.city = coder.decodeObject(forKey: "city") as? String
        self.zip = coder.decodeObject(forKey: "zip") as? String
        self.addressString = coder.decodeObject(forKey: "addressString") as? String
        self.phone = coder.decodeObject(forKey: "phone") as? String
        self.notes = coder.decodeObject(forKey: "notes") as? String
        self.web = coder.decodeObject(forKey: "web") as? String
        self.times = coder.decodeObject(forKey: "times") as? String
        self.favorite = coder.decodeBool(forKey: "favorite")
        self.location = GeoLocation(lat: self.lat, lng: self.lng)
        super.init()
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(self.cat, forKey: "cat")
        coder.encode(self.lat, forKey: "lat")
        coder.encode(self.lng, forKey: "lng")
        coder.encode(self.org, forKey: "org")
        coder.encode(self.street, forKey: "street")
        coder.encode(self.city, forKey: "city")
        coder.encode(self.zip, forKey: "zip")
        coder.encode(self.addressString, forKey: "addressString")
        coder.encode(self.phone, forKey: "phone")
        coder.encode(self.notes, forKey: "notes")
        coder.encode(self.web, forKey: "web")
        coder.encode(self.times, forKey: "times")
        coder.encode(self.favorite, forKey: "favorite")
    }

    
}

extension FoodSource: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return self.location.coordinate }
    
    var title: String? {
        var theTitle:String = ""
        /*if let first = self.name {
            theTitle = theTitle + first
        }*/
        if let theOrg = self.org {
            theTitle = theTitle + theOrg
        }
        
      // print("This is title: \(theTitle)")
        return theTitle
    }
    
}

extension FoodSource: Alertable {
    
    @available(iOS 8.0, *)
    func alert() -> UIAlertController {
        
        
        let alert = UIAlertController(title:nil, message:nil, preferredStyle: UIAlertController.Style.alert)
        
        
        var phone:String = ""
        var times:String = ""
        var notes:String = ""
        var web:String = ""
        let distance:String = ""
        
        var organization:String = ""
        if (self.org != nil) {
            organization = self.org!
        }
        
        
        if ((self.phone) != "") {
            phone = "Phone: " + self.phone! + "\n\n"
        }
        
        if ((self.times) != "") {
            times = "Hours: " + self.times! + "\n"
        }
        
        if ((self.notes) != "") {
            notes = "Notes: " + self.notes! + "\n"
        }
        
        if ((self.web) != "") {
            web = "Web: " + self.web! + "\n"
        }
        
     /*   if ((self.distance) != "") {
            distance = "Approx. Distance: " + self.distance! + " miles\n"
        }*/


        alert.title = "\(organization)"
        
        let moreInfo = phone + times + notes + distance + web

        
        //TODO:  add more stuff here for info
        if (self.street != nil && self.city != nil) {
            alert.message = " \(self.street!)\n \(self.city!)\n\n \(moreInfo)"
        }
             return alert
    }
    
}

