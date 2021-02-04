//
//  NewNote.swift
//  DigiBook
//
//  Created by Yannick Lehnhausen on 06.11.20.
//

import SwiftUI
import CoreData

struct NewNoteView: View {
	struct Options: Codable, Hashable {
		var options: Array<Dictionary<String,Array<String>>>
	}
	
	func parseJson() -> Options {
		let url = Bundle.main.url(forResource: "Options", withExtension: "json")!
		let data = try! Data(contentsOf: url)
		let decoder = JSONDecoder()
		let allOptions = try! decoder.decode(Options.self, from: data)
		return allOptions
	}
	
	
	@ObservedObject var note = Note()
	
	@ObservedObject var locationManager = LocationManager()
	@Environment(\.managedObjectContext) private var viewContext
	@Environment (\.presentationMode) var presentationMode
	
	@State private var cameramodel: String = ""
	@State private var lens: String = ""
	@State private var subject: String = ""
	@State private var shutterspeed = 0
	@State private var fStop = 0
	@State private var iso = 0
	@State private var isoString: String = ""
	@State private var shutterspeedString: String = ""
	@State private var filmtypeString: String = ""
	@State private var additionalNotes: String = ""
	@State private var format = 0
	@State private var filmtype = 0
	@State private var filmholder = 0
	@State private var isAnalog = true
	
	var body: some View {
		let allOptions = parseJson()
		Form {
			Toggle(isOn: $isAnalog){
				if(isAnalog) {
					Text("Analog")
				} else {
					Text("Digital")
				}
			}
			Section(header: Text("Subject")) {
				TextField("Subject", text: $subject)
			}
			Section(header: Text("Information")) {
				TextField("Camera", text: $cameramodel)
				TextField("Lens", text: $lens)
				if(isAnalog) {
					Picker(selection: $filmtype, label: Text("Filmtype")) {
						ForEach(0 ..< allOptions.options[0]["filmtype"]!.count) {
							Text(allOptions.options[0]["filmtype"]![$0])
						}
					}
					Picker(selection: $format, label: Text("Format")) {
						ForEach(0 ..< allOptions.options[0]["format"]!.count) {
							Text(allOptions.options[0]["format"]![$0])
						}
					}
					if(allOptions.options[0]["format"]![self.format] == "4x5") {
						Picker(selection: $filmholder, label: Text("Filmholder No.")) {
							ForEach(1 ..< 11) { i in
								Text("\(i)")
							}
						}
					}
				} else {
					Picker(selection: $iso, label: Text("ISO")) {
						ForEach(0 ..< allOptions.options[0]["iso"]!.count) {
							Text(allOptions.options[0]["iso"]![$0])
						}
					}
				}
			}
			Section(header: Text("Settings")) {
				Picker(selection: $shutterspeed, label: Text("Shutterspeed")) {
					ForEach(0 ..< allOptions.options[0]["shutterspeed"]!.count) {
						Text(allOptions.options[0]["shutterspeed"]![$0])
					}
				}
				Picker(selection: $fStop, label: Text("f-Stop")) {
					ForEach(0 ..< allOptions.options[0]["fStop"]!.count) {
						Text(allOptions.options[0]["fStop"]![$0])
					}
					
				}
			}
			if(allOptions.options[0]["shutterspeed"]![self.shutterspeed] == "Bulb" || allOptions.options[0]["shutterspeed"]![self.shutterspeed] == "Time") {
				TextField("Custom shutterspeed", text: $shutterspeedString)
			}
			if(allOptions.options[0]["filmtype"]![self.filmtype] == "Custom") {
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
		let allOptions = parseJson()
		let longitude = locationManager.lastLocation?.coordinate.longitude
		let latitude = locationManager.lastLocation?.coordinate.latitude
		let note = Note(context: viewContext)
		
		note.id = UUID()
		note.isAnalog = self.isAnalog;
		note.timestamp = Date()
		note.cameramodel = self.cameramodel
		note.lens = self.lens
		note.subject = self.subject
		if(self.shutterspeedString != "") {
			note.shutterspeed = self.shutterspeedString
		} else {
			note.shutterspeed = allOptions.options[0]["shutterspeed"]![self.shutterspeed]
		}
		if(self.isAnalog) {
			note.format = allOptions.options[0]["format"]![self.format]
			if(self.filmtypeString != "") {
				note.filmtype = self.filmtypeString
			} else {
				note.filmtype = allOptions.options[0]["filmtype"]![self.filmtype]
			}
		} else if(!self.isAnalog) {
			if(self.isoString != "") {
				note.filmtype = self.isoString
			} else {
				note.filmtype = allOptions.options[0]["iso"]![self.iso]
			}
		}
		note.fStop = self.fStopSelection[self.fStop]
		note.longitude = longitude!
		note.latitude = latitude!
		note.additionalNotes = self.additionalNotes
		
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
