//
//  MapVC.swift
//  PlavaTvornicaZadatakiOS
//
//  Created by Borut on 14/02/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    var currentLocation : String!
    var lat: CLLocationDegrees!
    var lon: CLLocationDegrees!
    @IBOutlet weak var mapShowCity: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let somestring = currentLocation
        geocoderForConvert(txtValue: somestring!)
    }
    
    func geocoderForConvert(txtValue: String)  {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(txtValue) { (placemarks, error) in
            //clouse where you get locations latitude and logitude by name of street or city
            let placemark = placemarks?.first
            self.lat = placemark?.location?.coordinate.latitude
            self.lon = placemark?.location?.coordinate.longitude
            guard let latituda = self.lat else {
                let alert = UIAlertController(title: "Error", message: "We couldn't find the location", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard let longituda = self.lon else {
                let alert = UIAlertController(title: "Error", message: "We couldn't find the location", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latituda, longituda)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            self.mapShowCity.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
