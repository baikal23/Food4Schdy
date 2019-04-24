/*
GeoLocation.swift
taken from Razeware TreasureHunt 
SJK 12/2014
*/

import Foundation
import MapKit

class GeoLocation :NSObject, NSCoding {
  var latitude: Double
  var longitude: Double

    init(lat:Double, lng:Double) {
        self.latitude = lat
        self.longitude = lng
        
     }
    
    required init?(coder decoder: NSCoder) {
        self.latitude = decoder.decodeDouble(forKey: "latitude")
        self.longitude = decoder.decodeDouble(forKey: "longitude")
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.latitude, forKey: "latitude")
        coder.encode(self.longitude, forKey: "longitude")
    }
    
    func distanceBetween(_ other: GeoLocation) -> Double {
        let locationA = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let locationB = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return locationA.distance(from: locationB)
    }
}

extension GeoLocation {
  
  var coordinate: CLLocationCoordinate2D { return CLLocationCoordinate2DMake(self.latitude, self.longitude) }
  
  var mapPoint: MKMapPoint { return MKMapPoint.init(self.coordinate) }
  
}

//extension GeoLocation: Equatable {
extension GeoLocation {
}

func ==(lhs: GeoLocation, rhs: GeoLocation) -> Bool {
  return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
