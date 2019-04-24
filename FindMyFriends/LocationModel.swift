//
//  LocationModel.swift
//  GetLocation
//
//  Created by Susan Kohler on 1/3/15.
//  Copyright (c) 2015 Susan Kohler. All rights reserved.
//

import Foundation

//class LocationModel: NSObject, CustomStringConvertible {
class LocationModel: NSObject {
    var lat:Double
    var lng:Double
    
    override var description: String {
        return "Lat: \(lat), Longitude: \(lng)\n"
    }
    
    init(lat:Double?, lng:Double?) {
        self.lat = lat ?? 0.0
        self.lng = lng ?? 0.0
    }
}