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
		MKMapView(frame: .zero)
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
