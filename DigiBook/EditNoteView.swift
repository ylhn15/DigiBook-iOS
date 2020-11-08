//
//  NewNote.swift
//  DigiBook
//
//  Created by Yannick Lehnhausen on 06.11.20.
//

import SwiftUI
import CoreData

struct EditNoteView: View {
	var note: Note?
	
	@ObservedObject var locationManager = LocationManager()
	@Environment(\.managedObjectContext) private var viewContext
	@Environment (\.presentationMode) var presentationMode
	
	@State private var cameramodel: String = ""
	@State private var lens: String = ""
	@State private var subject: String = ""
	@State private var shutterspeed = 0
	@State private var fStop = 0
	@State private var shutterspeedString: String = ""
	@State private var filmtypeString: String = ""
	@State private var additionalNotes: String = ""
	@State private var filmtype = 0
	
	var fStopSelection = ["1.0", "1.2", "1.4", "1.8", "2.0", "2.8", "4", "5.6", "8", "11", "16", "22", "32", "45", "64", "90", "128", "180", "256"]
	var shutterspeedSelection = ["1/8000", "1/4000", "1/2000", "1/1000", "1/500", "1/250", "1/125", "1/60", "1/30", "1/15", "1/8", "1/4", "1/2", "1", "Bulb", "Time"]
	var filmtypeSelection = ["Ilford HP5", "Ilford FP4",  "Ilford Delta 400", "Ilford Delta 3200", "TMAX 100", "Ektar 100", "Fomapan 100", "Fomapan 200", "Portra 400", "Portra 800", "Custom"]
	
	
	var body: some View {
		Form {
			Section(header: Text("Subject")) {
				TextField("Subject", text: $subject)
			}
			Section(header: Text("Information")) {
				TextField("Camera", text: $cameramodel)
				TextField("Lens", text: $lens)
				Picker(selection: $filmtype, label: Text("Filmtype")) {
					ForEach(0 ..< filmtypeSelection.count) {
						Text(self.filmtypeSelection[$0])
					}
				}
			}
			Section(header: Text("Settings")) {
				Picker(selection: $shutterspeed, label: Text("Shutterspeed")) {
					ForEach(0 ..< shutterspeedSelection.count) {
						Text(self.shutterspeedSelection[$0])
					}
				}
				Picker(selection: $fStop, label: Text("f-Stop")) {
					ForEach(0 ..< fStopSelection.count) {
						Text(self.fStopSelection[$0])
					}
					
				}
			}
			if(self.shutterspeedSelection[self.shutterspeed] == "Bulb" || self.shutterspeedSelection[self.shutterspeed] == "Time") {
				TextField("Custom shutterspeed", text: $shutterspeedString)
			}
			if(self.filmtypeSelection[self.filmtype] == "Custom") {
				TextField("Custom film", text: $filmtypeString)
			}
			TextField("Additional notes", text: $additionalNotes)
		}
		//.padding()
		//.keyboardAdaptive()
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				HStack {
					Button(action: addNote) {
						Text("Save")
					}
				}
			}
		}
		.navigationBarTitle(Text("New Note"))
	}
	
	private func addNote() {
		let longitude = locationManager.lastLocation?.coordinate.longitude
		let latitude = locationManager.lastLocation?.coordinate.latitude
		let note = Note(context: viewContext)
		
		note.id = UUID()
		note.timestamp = Date()
		note.cameramodel = self.cameramodel
		note.lens = self.lens
		note.subject = self.subject
		if(self.shutterspeedString != "") {
			note.shutterspeed = self.shutterspeedString
		} else {
			note.shutterspeed = self.shutterspeedSelection[self.shutterspeed]
		}
		if(self.filmtypeString != "") {
			note.filmtype = self.filmtypeString
		} else {
			note.filmtype = self.filmtypeSelection[self.filmtype]
		}
		note.fStop = self.fStopSelection[self.fStop]
		note.longitude = longitude!
		note.latitude = latitude!
		
		do {
			try viewContext.save()
			presentationMode.wrappedValue.dismiss()
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			let nsError = error as NSError
			fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}
}
