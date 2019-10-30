//
//  LTMapController.swift
//  coolPer
//
//  **********************************************
//  *     _    _        _ˍ_ˍ_        _    _      *
//  *    | |  | |      |__   |      \ \  / /     *
//  *    | |__| |        /  /        \ \/ /      *
//  *    |  __  |       /  /          \  /       *
//  *    | |  | |      /  /__       __/ /        *
//  *    |_|  |_|      |_ˍ_ˍ_|     |_ˍ_/         *
//  *                                            *
//  **********************************************
//
//  Created by LonTe on 2019/10/19.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit
import MapKit

class LTMapController: LTViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now()+1) {
            mapView.setRegion(mapView.regionThatFits(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 22.5533990000, longitude: 113.9468090000), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))), animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
