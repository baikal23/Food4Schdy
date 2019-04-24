//
//  ViewController.swift
//  FindMyFriends
//
//  Created by Susan Kohler on 12/29/14.
//  Copyright (c) 2014 Susan Kohler. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import CoreLocation
import MessageUI
import SwiftyJSON



class ViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet var mapView : MKMapView!
    @IBOutlet weak var snapButton: UIButton!
    @IBOutlet weak var brandConvButton: UIButton!
    @IBOutlet weak var produceButton: UIButton!
    @IBOutlet weak var groceryButton: UIButton!
    @IBOutlet weak var summerButton: UIButton!
    @IBOutlet weak var holidayButton: UIButton!
    @IBOutlet weak var pantryButton: UIButton!
    @IBOutlet weak var localConv: UIButton!
    @IBOutlet weak var communityButton: UIButton!
    fileprivate var buttonString = ""
    fileprivate var activeGroupIndex:Int = 0
    fileprivate var addressCount:Int = 0
    fileprivate var newFoodSources:[FoodSource] = []
    fileprivate var sourcesToDisplay:[FoodSource] = []
    fileprivate var foodSourceArray:[FoodSource] = []
    fileprivate var favoritesArray:[FoodSource] = []
    fileprivate var polyline: MKPolyline!
    fileprivate var currentFoodSource = FoodSource(cat:"Sue",lat: 0.0, lng:0.0)
    var centralSource = FoodSource(cat: "Center", lat: 42.8110844, lng: -73.9368202)
    var myLocation:CLLocation!
 
    let locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    var allFoodSources: NSArray?

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var InfoButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        /* quick test
        let newPerson = Person(name: "Joe", age: 10)
        let person2 = Person(name: "Sue", age: 12)
        var people = [Person]()
        people.append(newPerson)
        people.append(person2)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: people)
        UserDefaults.standard.set(encodedData, forKey: "people")
        let cat = "Test"
        let lat = 1.23
        let lng = 4.56
        let location = GeoLocation(lat: lat, lng: lng)
        var foods = [FoodSource]()
        let currentFoodSource = FoodSource(cat: cat, lat: lat, lng: lng)
        currentFoodSource.notes = "note"
        currentFoodSource.web = "web1"
        currentFoodSource.org = "Org"
        currentFoodSource.street = "Street"
        currentFoodSource.city = "City"
        currentFoodSource.zip = "Zip"
        currentFoodSource.phone = "Phone"
        currentFoodSource.times = "Times"
        let currentFoodSource2 = FoodSource(cat: cat, lat: lat, lng: lng)
        currentFoodSource2.notes = "note2"
        currentFoodSource2.web = "web2"
        currentFoodSource2.org = "Org2"
        currentFoodSource2.street = "Street2"
        currentFoodSource2.city = "City2"
        currentFoodSource2.zip = "Zip2"
        currentFoodSource2.phone = "Phone2"
        currentFoodSource2.times = "Times2"

        foods.append(currentFoodSource)
        foods.append(currentFoodSource2)
        let encodedData2 = NSKeyedArchiver.archivedData(withRootObject: foods)
        UserDefaults.standard.set(encodedData2, forKey: "foods")


        // retrieving a value for a key
        if let data = UserDefaults.standard.data(forKey: "people"),
            let myPeopleList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Person] {
            myPeopleList.forEach({print( $0.name, $0.age)})  // Joe 10
        } else {
            print("There is an issue")
        }
        if let data2 = UserDefaults.standard.data(forKey: "foods"),
            let myFoodsList = NSKeyedUnarchiver.unarchiveObject(with: data2) as? [FoodSource] {
            myFoodsList.forEach({print( $0.org, $0.street, $0.city)})  // Joe 10
        } else {
            print("There is an issue")
        }
        //end */
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true    // this makes pulsationg blue dot - UGH
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        } else {
            print("Location services are not enabled");
            let alertController = UIAlertController(title: "Oops", message:
                "You need to enable Location Services.\n Do this in Settings and try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return

        }
        
        self.setupButtons() // for the two liners
        self.resetButtons() // make backgrounds clear to start
        self.checkDatabaseVersion() // checks version and loads new or current database

        self.updateMap()
    }
    
    @IBAction func holidayButtonPressed(_ sender: AnyObject) {
        if (holidayButton.backgroundColor == UIColor.clear) {
            holidayButton.backgroundColor = UIColor.black
        } else {
            holidayButton.backgroundColor = UIColor.clear
        }
        self.updateMap()
     
    }
    
    @IBAction func pantryButtonPressed(_ sender: AnyObject) {
        if (pantryButton.backgroundColor == UIColor.clear) {
            pantryButton.backgroundColor = UIColor.yellow
        } else {
            pantryButton.backgroundColor = UIColor.clear
        }
        self.updateMap()
      
    }
    
    @IBAction func localConvButtonPressed(_ sender: AnyObject) {
        if (localConv.backgroundColor == UIColor.clear) {
            //localConv.backgroundColor = UIColor.lightGrayColor()
            localConv.backgroundColor = UIColor.blue
        } else {
            localConv.backgroundColor = UIColor.clear
        }
        self.updateMap()
       
    }
    

    @IBAction func snapButtonPressed(_ sender: AnyObject) {
        if (snapButton.backgroundColor == UIColor.clear) {
             snapButton.backgroundColor = UIColor.orange
        } else {
            snapButton.backgroundColor = UIColor.clear
        }
        self.updateMap()
     
    }
    
    @IBAction func brandConvButtonPressed(_ sender: AnyObject) {
        if (brandConvButton.backgroundColor == UIColor.clear) {
             brandConvButton.backgroundColor = UIColor.red
        } else {
            brandConvButton.backgroundColor = UIColor.clear
        }
        self.updateMap()
        
        
    }
    @IBAction func communityButtonPressed(_ sender: AnyObject) {
        if (communityButton.backgroundColor == UIColor.clear) {
            communityButton.backgroundColor = UIColor.brown
        } else {
            communityButton.backgroundColor = UIColor.clear
        }
        self.updateMap()
     
    }
    @IBAction func produceButtonPressed(_ sender: AnyObject) {
        if (produceButton.backgroundColor == UIColor.clear) {
            produceButton.backgroundColor = UIColor.green
        } else {
            produceButton.backgroundColor = UIColor.clear
        }
        self.updateMap()
        
    }
    @IBAction func groceryButtonPressed(_ sender: AnyObject) {
        if (groceryButton.backgroundColor == UIColor.clear) {
            groceryButton.backgroundColor = UIColor.purple
        } else {
            groceryButton.backgroundColor = UIColor.clear
        }
        self.updateMap()
        
    }
    @IBAction func summerButtonPressed(_ sender: AnyObject) {
        if (summerButton.backgroundColor == UIColor.clear) {
            summerButton.backgroundColor = UIColor.orange
        } else {
            summerButton.backgroundColor = UIColor.clear
        }
        self.updateMap()
        
    }
    
    @IBAction func favoritesPresed(_ sender: AnyObject) {
        print("Favorite presssed")
        self.resetButtons() // get rid of other selections
        self.getFavorites()
        if (favoritesArray.count == 0) {
            let alertController = UIAlertController(title: "Oops", message:
                "First you need to mark some favorites. \n Try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        sourcesToDisplay = favoritesArray
        self.updateMapWithFavorites()
        
    }
    
    @IBAction func searchPressed(_ sender: AnyObject) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Search", message: "Enter name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0]
            self.searchForString(textField.text!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    func checkDatabaseVersion() {
        
        DispatchQueue.main.async(execute: {() -> () in
            self.activityIndicator.startAnimating()
        })
        
       // let versionUrl: URL = URL(string: "https://host239.hostmonster.com/~sicmfood/foodmap10.php?version=1")!
        let versionUrl: URL = URL(string: "https://sicmfood.com/foodmap10.php?version=1")!
        let versionRequest = NSMutableURLRequest(url: versionUrl)
        versionRequest.httpMethod = "POST"
       
        let versionTask = URLSession.shared.dataTask(with: versionRequest as URLRequest , completionHandler: {
                data, response, error in
                // print(response)  this is not the output we want
                if(error != nil)
                {
                    print("error=\(String(describing: error))")
                    return
                }
                
                //let versionJSON = JSON(data:data!)
            var versionJSON:JSON
            
            do {
                versionJSON = try JSON(data: data!)
            } catch _ {
                versionJSON = JSON.null
            }
                self.handleVersionJSON(versionJSON)

                
        })

        versionTask.resume()
    }
    
    func handleVersionJSON(_ json: JSON) {
        var savedVersion = ""
        let versionArchive = Filehelpers.pathInUserDocumentDirectory("versionArchive")
        let manager = FileManager.default
        let versionData = manager.contents(atPath: versionArchive) as Data?
        if (versionData == nil ) {
            savedVersion = ""
        } else {
            if let oldVersion = NSKeyedUnarchiver.unarchiveObject(with: versionData!) as? String {
                
                print("Old version is \(oldVersion)")
                savedVersion = oldVersion
            }
        }
        
        print("Saved version is \(savedVersion)")
        
            let version = json["Version"].stringValue
            print("Version ID is \(version)")
            if version != savedVersion {
                self.updateDatabase()
                print(version) // this is what we want - it is the data in JSON form
                let versionArchive = Filehelpers.pathInUserDocumentDirectory("versionArchive")
                
                let dataToSave = NSKeyedArchiver.archivedData(withRootObject: version)
                
                try? dataToSave.write(to: URL(fileURLWithPath: versionArchive), options: [.atomic])
            } else {
                self.loadDatabase()  // load local copy
            }

        

        
    }

    func updateDatabase() {
        DispatchQueue.main.async(execute: {() -> () in
           self.activityIndicator.startAnimating()
        })

        newFoodSources = [] // empty the array
    
        //let url: URL = URL(string: "https://host239.hostmonster.com/~sicmfood/foodmap10.php?" + buttonString)!
        let url: URL = URL(string: "https://sicmfood.com/foodmap10.php?" + buttonString)!
        let request = NSMutableURLRequest(url: url)

        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
                data, response, error in
                // print(response)  this is not the output we want
                if(error != nil)
                {
                    print("error=\(String(describing: error))")
                    return
                }
                //let swifty = JSON(data:data!)
            var swifty:JSON
            
            do {
                swifty = try JSON(data: data!)
            } catch _ {
                swifty = JSON.null
            }
            
            self.parseJSON(swifty)
        })
        task.resume()
    }
    
    func parseJSON(_ json: JSON) {
       // var testNumber = 0
        for result in json["Food"].arrayValue {
            let cat = result["Cat"].stringValue
            let lat = result["Lat"].numberValue
            let lng = result["Lng"].numberValue
            let currentFoodSource = FoodSource(cat: cat, lat: Double(truncating: lat), lng: Double(truncating: lng))
            currentFoodSource.notes = result["Notes"].stringValue
            currentFoodSource.web = result["Web"].stringValue
            currentFoodSource.org = result["Org"].stringValue
            currentFoodSource.street = result["Street"].stringValue
            currentFoodSource.city = result["City"].stringValue
            currentFoodSource.zip = result["Zip"].stringValue
            currentFoodSource.phone = result["Phone"].stringValue
            currentFoodSource.times = result["Times"].stringValue
            print(cat)
            print(currentFoodSource.street!)
            print(currentFoodSource.city!)
            newFoodSources.append(currentFoodSource)
           // testNumber = testNumber + 1
           // print("Test number is \(testNumber)")
        }
        
        
        print("We have \(newFoodSources.count) items downloaded")
        self.saveFoodSources(newFoodSources)
        self.loadDatabase()

    }
    
    
    func resetButtons() {

        snapButton.isHighlighted = false
        pantryButton.isHighlighted = false
        produceButton.isHighlighted = false
        brandConvButton.isHighlighted = false
        localConv.isHighlighted = false
        groceryButton.isHighlighted = false
        communityButton.isHighlighted = false
        holidayButton.isHighlighted = false
        summerButton.isHighlighted = false
        
        snapButton.backgroundColor = UIColor.clear
        pantryButton.backgroundColor = UIColor.clear
        produceButton.backgroundColor = UIColor.clear
        brandConvButton.backgroundColor = UIColor.clear
        localConv.backgroundColor = UIColor.clear
        groceryButton.backgroundColor = UIColor.clear
        communityButton.backgroundColor = UIColor.clear
        holidayButton.backgroundColor = UIColor.clear
        summerButton.backgroundColor = UIColor.clear
        
    }
    func setupButtons() {
        snapButton.titleLabel?.lineBreakMode = .byWordWrapping
        snapButton.titleLabel?.textAlignment = .center
        snapButton.setTitle("SNAP\nVendors", for: UIControl.State())
        
        pantryButton.titleLabel?.lineBreakMode = .byWordWrapping
        pantryButton.titleLabel?.textAlignment = .center
        pantryButton.setTitle("Food\nPantries", for: UIControl.State())
        
        communityButton.titleLabel?.lineBreakMode = .byWordWrapping
        communityButton.titleLabel?.textAlignment = .center
        communityButton.setTitle("Community\nMeals", for: UIControl.State())
        
        summerButton.titleLabel?.lineBreakMode = .byWordWrapping
        summerButton.titleLabel?.textAlignment = .center
        summerButton.setTitle("Summer\nMeals", for: UIControl.State())
        
        groceryButton.titleLabel?.lineBreakMode = .byWordWrapping
        groceryButton.titleLabel?.textAlignment = .center
        groceryButton.setTitle("Large\nGroceries", for: UIControl.State())
        
        holidayButton.titleLabel?.lineBreakMode = .byWordWrapping
        holidayButton.titleLabel?.textAlignment = .center
        holidayButton.setTitle("Holiday\nMeals", for: UIControl.State())
        
        brandConvButton.titleLabel?.lineBreakMode = .byWordWrapping
        brandConvButton.titleLabel?.textAlignment = .center
        brandConvButton.setTitle("Limited\nGroceries", for: UIControl.State())
        
        localConv.titleLabel?.lineBreakMode = .byWordWrapping
        localConv.titleLabel?.textAlignment = .center
        localConv.setTitle("Local\nStores", for: UIControl.State())
        
        produceButton.titleLabel?.lineBreakMode = .byWordWrapping
        produceButton.titleLabel?.textAlignment = .center
        produceButton.setTitle("Produce\nMarkets", for: UIControl.State())
        
    }
    // MARK: - CoreLocation Delegate Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        //removeLoadingView()
        
        print(error, terminator: "")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        _ = locationObj.coordinate
        //print(coord.latitude)
      //  print(coord.longitude)
        myLocation = locationObj
        locationManager.stopUpdatingLocation()
        self.addMeToMap()
        
    }
    
    func addMeToMap() {
        if (myLocation == nil) {
            let alertController = UIAlertController(title: "We can't find you!", message:
                "You need to enable Location Services.\n Do this in Settings and try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let myPin = MKPointAnnotation()
        myPin.coordinate = myLocation.coordinate
        let myCoordinate = GeoLocation(lat: myLocation.coordinate.latitude, lng: myLocation.coordinate.longitude)
       // self.mapView.addAnnotation(myPin)
        let distance = centralSource.location.distanceBetween(myCoordinate)
        var mapDistance:Double
        if (distance > 4000.0) {
            mapDistance = distance * 2.0
        } else {
            mapDistance = 4000
        }
        let region = MKCoordinateRegion.init(center: myPin.coordinate, latitudinalMeters: mapDistance, longitudinalMeters: mapDistance)
        self.mapView.setRegion(region, animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // these next two lines lower memory for MKMaps
        self.mapView.mapType = MKMapType.hybrid
        self.mapView.mapType = MKMapType.standard

        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        // these next two lines lower memory for MKMaps
        self.mapView.mapType = MKMapType.hybrid
        self.mapView.mapType = MKMapType.standard
    }
    @IBAction func cancelToViewController(_ segue:UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
 
    
    func loadDatabase() {
        
        
        // get saved FoodSources with lat long
        let foodSourceArchive = Filehelpers.pathInUserDocumentDirectory("foodSourceArchive")
        let manager = FileManager.default
        let foodData = manager.contents(atPath: foodSourceArchive) as Data?
        //let foodData = UserDefaults.standard.data(forKey: "foodSources")
        if (foodData == nil ) {
            let alertController = UIAlertController(title: "Oops", message:
                "First you need to select seach options. \n Try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        //if let foodSources = NSKeyedUnarchiver.unarchiveObject(with: foodData!) as? [FoodSource] {
        if let foodSources = NSKeyedUnarchiver.unarchiveObject(with: foodData!) as? [FoodSource] {
            print("We have \(foodSources.count) items from archive")
            foodSourceArray = foodSources
        }
        DispatchQueue.main.async(execute: {() -> () in
            self.activityIndicator.stopAnimating()
        })

    }
    
    func updateMap() {
        if (CLLocationManager.locationServicesEnabled()) {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            self.mapView.removeAnnotations(mapView.annotations) //remove all annotations
            self.getSourcesToDisplay() // the food sources to display now
            DispatchQueue.main.async(execute: {() -> () in
                self.mapView.addAnnotations(self.sourcesToDisplay)
            })

        } else {
            print("Location services are not enabled");
            let alertController = UIAlertController(title: "Oops", message:
                "You need to enable Location Services.\n Do this in Settings and try again.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
            
        }
            /*locationManager.startUpdatingLocation()
            self.mapView.removeAnnotations(mapView.annotations) //remove all annotations
            self.getSourcesToDisplay() // the food sources to display now
            dispatch_async(dispatch_get_main_queue(), {() -> () in
                self.mapView.addAnnotations(self.sourcesToDisplay)
            })*/
 
    }
    
    func updateMapWithFavorites() {
        locationManager.startUpdatingLocation()
        self.mapView.removeAnnotations(mapView.annotations) //remove all annotations
        DispatchQueue.main.async(execute: {() -> () in
            self.mapView.addAnnotations(self.sourcesToDisplay)
        })
        
    }
    
    func updateMapWithArray(_ arrayToUse:Array<FoodSource>) {
        
        locationManager.startUpdatingLocation()
        self.mapView.removeAnnotations(mapView.annotations) //remove all annotations
        DispatchQueue.main.async(execute: {() -> () in
            self.mapView.addAnnotations(arrayToUse)
        })
        
    }
    
    func saveFoodSources(_ foodSourcesArray: Array<FoodSource>) {
        let foodSourceArchive = Filehelpers.pathInUserDocumentDirectory("foodSourceArchive")
        
        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: foodSourcesArray)
        
        try? dataToSave.write(to: URL(fileURLWithPath: foodSourceArchive), options: [.atomic])
       // UserDefaults.standard.set(dataToSave, forKey: "foodSources")

        //TODO - check here

    }
    
    func saveFavorites() {
        let favoritesArchive = Filehelpers.pathInUserDocumentDirectory("favoritesArchive")
        
        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: favoritesArray)
        
        try? dataToSave.write(to: URL(fileURLWithPath: favoritesArchive), options: [.atomic])

    }
    
    func getFavorites() {
        
        
        // get saved FoodSources with lat long
        let favoritesArchive = Filehelpers.pathInUserDocumentDirectory("favoritesArchive")
        let manager = FileManager.default
        let favoritesData = manager.contents(atPath: favoritesArchive) as Data?
        if (favoritesData == nil ) {
           /* let alertController = UIAlertController(title: "Oops", message:
                "First you need to mark some favorites. \n Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)*/
            return
        }
        if let favoritesSources = NSKeyedUnarchiver.unarchiveObject(with: favoritesData!) as? Array<FoodSource> {
            
            print("We have \(favoritesSources.count) items from favorites")
            favoritesArray = favoritesSources
        }
    }

    func getSourcesToDisplay() {
        
        sourcesToDisplay = []  // start with empty array
        //let myCoordinate = GeoLocation(lat: myLocation.coordinate.latitude, lng: myLocation.coordinate.longitude)
        for item in foodSourceArray {
           // let distanceNumber  = item.location.distanceBetween(myCoordinate)
           // item.distance = "\(distanceNumber)"
            if (snapButton.backgroundColor != UIColor.clear) {
                if item.cat == "SNAP" {
                    sourcesToDisplay.append(item)
                }
            }
            
            if  (pantryButton.backgroundColor != UIColor.clear) {
                if item.cat == "PANTRY" {
                    sourcesToDisplay.append(item)
                }
            }
            
            if (produceButton.backgroundColor != UIColor.clear) {
                if item.cat == "PRODUCE" {
                    sourcesToDisplay.append(item)
                }
            }
            
            if (brandConvButton.backgroundColor != UIColor.clear) {
                if item.cat == "BNCONV" {
                    sourcesToDisplay.append(item)
                }
            }
            
            if (localConv.backgroundColor != UIColor.clear) {
                if item.cat == "NEIGHCONV" {
                    sourcesToDisplay.append(item)
                }
            }
            
            if (groceryButton.backgroundColor != UIColor.clear) {
                if item.cat == "GROCER" {
                    sourcesToDisplay.append(item)
                }
            }
            
            if (communityButton.backgroundColor != UIColor.clear) {
                if item.cat == "COMM" {
                    sourcesToDisplay.append(item)
                }
            }
            if (holidayButton.backgroundColor != UIColor.clear) {
                if item.cat == "HOLIDAY" {
                    sourcesToDisplay.append(item)
                }
            }
            
            if (summerButton.backgroundColor != UIColor.clear) {
                if item.cat == "SUMMER LUNCH" {
                    sourcesToDisplay.append(item)
                }
            }

        }
    }
    
    func searchForString(_ testString:String) {
        // code to test search string
        var searchArray:Array<FoodSource> = []
        let searchString = testString
        let newString = searchString.lowercased()
        
        for item in foodSourceArray {
            let testString = item.org!.lowercased()
            if testString.range(of: newString) != nil {
                print("\(String(describing: item.org))" + "\n")
                searchArray.append(item)
            }
        }
        updateMapWithArray(searchArray)
    }
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let food = annotation as? FoodSource {
            //var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as! MKPinAnnotationView!
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: food.cat)  // each type unique
            if view == nil {
                
                //view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                
                view = SicmAnnotationView(annotation: annotation, reuseIdentifier: food.cat)
                view!.canShowCallout = true
                //view!.animatesDrop = false
                view!.calloutOffset = CGPoint(x: -5, y: 5)
                view!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            } else {
                view!.annotation = annotation
            }
            
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let food = view.annotation as? FoodSource {
            let alertable = food
                let alert = alertable.alert()
            
                alert.addAction(UIAlertAction(title: "Go to Maps App to find route", style: UIAlertAction.Style.default) { action in
                    self.findRoute(food)
                    })
            if ((food.phone != nil) && (food.phone != "")) {
                alert.addAction(UIAlertAction(title: "Phone", style: UIAlertAction.Style.default) { action in
                    self.callFoodSource(food)
                    })
               
            }
            if ((food.web != nil) && (food.web != "")) {
                alert.addAction(UIAlertAction(title: "Go to Website", style: UIAlertAction.Style.default) { action in
                    self.goToWebsite(food)
                    })
                
            }
            if food.favorite == false {
                alert.addAction(UIAlertAction(title: "Add to Favorites", style: UIAlertAction.Style.default) { action in
                    self.addToFavorites(food)
                    })
            } else {
                alert.addAction(UIAlertAction(title: "Remove from Favorites", style: UIAlertAction.Style.default) { action in
                    self.removeFromFavorites(food)
                    })
            }
            
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineOverlay = overlay as? MKPolyline 
            let renderer = MKPolylineRenderer(polyline: polylineOverlay!)
            renderer.strokeColor = UIColor.yellow
        
            return renderer
       
    }
    
    
    
    func parseTextField(_ original:String) -> String {
        let noNewLine = original.replacingOccurrences(of: "\n", with: " ")
        //var withCommas = noNewLine.stringByReplacingOccurrencesOfString(" ", withString:" ")
        
        return noNewLine
    }
    
    func condenseWhitespace(_ string: String) -> String {
        //let components = string.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.characters.isEmpty})
        let components = string.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter({!$0.isEmpty})
        return components.joined(separator: "")
    }

    func parsePhoneNumber(_ phoneString: String) -> String {
        var phone = phoneString
        phone = phone.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        phone = phone.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        phone = phone.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        phone = condenseWhitespace(phone)
        return phone
    }

    func callFoodSource(_ food:FoodSource){
        var phone = food.phone

        phone = parsePhoneNumber(phone!)
        phone = "tel://" + phone!
        let url:URL = URL(string:phone!)!;
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
        self.updateMap()
    }
    
    func goToWebsite(_ food:FoodSource) {
        if let website = food.web {
            UIApplication.shared.open(URL(string: website)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    func addToFavorites(_ food:FoodSource) {
        food.favorite = true
        self.getFavorites()
        favoritesArray.append(food)
        self.saveFavorites()
    }
    
    func removeFromFavorites(_ food:FoodSource) {
        food.favorite = false
        self.getFavorites()
        for index in 0..<favoritesArray.count  {
            let item = favoritesArray[index]
            if ((item.location.latitude == food.location.latitude) && (item.location.longitude == food.location.longitude)) {
                favoritesArray.remove(at: index)
                self.saveFavorites()
                return
            }
            
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion:nil)
    }
    
    func findRoute(_ food:FoodSource) {
        if (myLocation == nil) {
            let alertController = UIAlertController(title: "We can't find you!", message:
                "You need to enable Location Services.\n Do this in Settings and try again.", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
        }
        let sourcePlacemark:MKPlacemark = MKPlacemark(coordinate: myLocation.coordinate, addressDictionary: nil)
        let destinationPlacemark:MKPlacemark = MKPlacemark(coordinate: food.coordinate, addressDictionary: nil)
        let source:MKMapItem = MKMapItem(placemark: sourcePlacemark)
        source.name = "From You"
        let destination:MKMapItem = MKMapItem(placemark: destinationPlacemark)
        
        if let endName = food.org {
            destination.name = endName
        } else {
            destination.name = "Your Food Source"
        }
        /* directions within my app
        var directionRequest:MKDirectionsRequest = MKDirectionsRequest()
        directionRequest.setSource(source)
        directionRequest.setDestination(destination)
        directionRequest.transportType = MKDirectionsTransportType.Automobile
        directionRequest.requestsAlternateRoutes = true
        
        var directions:MKDirections = MKDirections(request: directionRequest)
        directions.calculateDirectionsWithCompletionHandler({
        (response: MKDirectionsResponse!, error: NSError?) in
        if error != nil{
        println("Error")
        }
        if response != nil{
        println(response.description)
        var route = response.routes[0] as MKRoute
        self.polyline = route.polyline!
        self.mapView.addOverlay(self.polyline)
        var instructions = route.steps[0].instructions as String
        println("\(instructions) \n")
        instructions = route.steps[1].instructions as String
        println("\(instructions)")
        }
        else{
        println("No response")
        }
        println(error?.description)
        })
        // end of trying directions */
        
        // heres an attempt to open Maps
        
        let mapItem:MKMapItem = destination
        
        //let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey)
        
       // let launchOptions:NSDictionary = NSDictionary(object: 0, forKey: MKLaunchOptionsMapTypeKey)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsMapTypeKey:0] as [String : Any]
        let currentLocationMapItem:MKMapItem = source
        
        // these next two lines lower memory for MKMaps
        self.mapView.mapType = MKMapType.hybrid
        self.mapView.mapType = MKMapType.standard
        MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: launchOptions as [String : AnyObject])

    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
