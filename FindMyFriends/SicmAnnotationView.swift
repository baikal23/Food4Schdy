//
//  SicmAnnotationView.swift
//  ContactMap
//
//  Created by Susan Kohler on 10/31/15.
//  Copyright © 2015 Susan Kohler. All rights reserved.
//

import UIKit
import MapKit

class SicmAnnotationView: MKAnnotationView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init (annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let food = self.annotation as! FoodSource
        
        switch (food.cat) {
            case "SNAP":
                image = UIImage(named: "orangeStar.png")
            case "NEIGHCONV":
                image = UIImage(named: "blueStar.png")
            case "PANTRY":
                image = UIImage(named: "yellowStar.png")
            case "BNCONV":
                image = UIImage(named: "redStar.png")
            case "COMM":
                image = UIImage(named: "brownStar.png")
            case "GROCER":
                image = UIImage(named: "purpleStar.png")
            case "PRODUCE":
                image = UIImage(named: "greenStar.png")
            case "HOLIDAY":
                image = UIImage(named: "blackStar.png")
            case "SUMMER":
                image = UIImage(named: "yellowRedStar.png")
            default:
                image = UIImage(named: "yellowRedStar.png")
        }

    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
