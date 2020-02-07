//
//  ViewController.swift
//  SampleMapApp
//
//  Created by 廣澤智明 on 2020/02/01.
//  Copyright © 2020 廣澤智明. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    var locationManager : CLLocationManager!
    let annotation = MKPointAnnotation()
    var localCount = 0
    var parentView: UIView!

    @IBOutlet weak var mkMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        parentView = self.view

        locationManager = CLLocationManager()
        locationManager.allowsBackgroundLocationUpdates = true; // バックグランドモードで使用する場合YESにする必要がある
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 位置情報取得の精度
        locationManager.distanceFilter = 1; // 位置情報取得する間隔、1m単位とする
        locationManager.delegate = self
        mkMapView.delegate = self

        // 位置情報の認証チェック
        let status = CLLocationManager.authorizationStatus()
        if (status == .notDetermined) {
            print("許可、不許可を選択してない");
            // 常に許可するように求める
            locationManager.requestAlwaysAuthorization();
        }
        else if (status == .restricted) {
            print("機能制限している");
        }
        else if (status == .denied) {
            print("許可していない");
        }
        else if (status == .authorizedWhenInUse) {
            print("このアプリ使用中のみ許可している");
            locationManager.startUpdatingLocation();
        }
        else if (status == .authorizedAlways) {
            print("常に許可している");
            locationManager.startUpdatingLocation();
        }
        
    }

}

extension UIView {
}

extension ViewController: CLLocationManagerDelegate {
    // 位置情報が取得されると呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最新の位置情報を取得 locationsに配列で入っている位置情報の最後が最新となる
        let location = locations.last
        let latitude = location?.coordinate.latitude ?? 0
        let longitude = location?.coordinate.longitude ?? 0
        let locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        

        annotation.coordinate = locationCoordinate
        mkMapView.removeAnnotation(annotation)
        mkMapView.addAnnotation(annotation)

        mkMapView.setCenter(locationCoordinate, animated: true)
        
    }
       
    // 位置情報の取得に失敗すると呼ばれる
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
    }
       
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           if (status == .restricted) {
               print("機能制限している");
           }
           else if (status == .denied) {
               print("許可していない");
           }
           else if (status == .authorizedWhenInUse) {
               print("このアプリ使用中のみ許可している");
               locationManager.startUpdatingLocation();
           }
           else if (status == .authorizedAlways) {
               print("常に許可している");
               locationManager.startUpdatingLocation();
           }
    }
}
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       let identifier = "pin"
       var annotationView: MKAnnotationView!

       if annotationView == nil {
           annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
       }
       // pinに表示する画像を指定
        let uiLabel = CustomAnnotationView()
        uiLabel.no.text = String(localCount)
        localCount+=1
        annotationView.image = uiLabel.snapshot()?.resize(size: CGSize(width: 80.0, height: 80.0))
       annotationView.annotation = annotation
       annotationView.canShowCallout = false

       return annotationView
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "datacell") as? CustomTableViewCell {
            cell.onClickListener = {() in
                let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
                let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: self.parentView)
                print("hirosawa test x:\(rectOfCellInSuperview.origin.x)")
                print("hirosawa test y:\(rectOfCellInSuperview.origin.y)")

            }
            return cell
        }
        return UITableViewCell()
    }
}
