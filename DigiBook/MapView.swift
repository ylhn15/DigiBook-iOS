//
//  MapView.swift
//  Tutorial
//
//  Created by Yannick Lehnhausen on 04.11.20.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
	var note: Note
	
	
	func makeUIView(context: Context) -> MKMapView {
		let mapView = WrappedMap()
		mapView.onLongPress = openMap(for:)
		return mapView
	}
	
	func openMap(for coordinate: CLLocationCoordinate2D) {
		var url = URL(string: "")
		if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
		{
			url = (URL(string: "comgooglemaps://?saddr=&daddr=\(note.latitude),\(note.longitude)&directionsmode=walking")! as URL)
		} else {
			url = URL(string:"http://maps.apple.com/?daddr=\(note.latitude),\(note.longitude)")!
		}
		UIApplication.shared.open(url!)
	}
	
	func updateUIView(_ uiView: MKMapView, context: Context) {
		let coordinate = CLLocationCoordinate2D(
			latitude: note.latitude, longitude: note.longitude
		)
		let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		uiView.setRegion(region, animated: true)
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		annotation.title = note.subject!
		uiView.addAnnotation(annotation)
		
		
	}
	
}
