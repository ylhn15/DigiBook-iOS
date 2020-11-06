//
//  NewNote.swift
//  DigiBook
//
//  Created by Yannick Lehnhausen on 06.11.20.
//

import SwiftUI
import CoreData

struct NewNoteView: View {
	@ObservedObject var locationManager = LocationManager()
	@Environment(\.managedObjectContext) private var viewContext
	@Environment (\.presentationMode) var presentationMode
	
	@State private var cameramodel: String = ""
	@State private var lens: String = ""
	@State private var subject: String = ""
	@State private var shutterspeed: String = ""
	@State private var fStop: String = ""
	@State private var additionalNotes: String = ""
	
	var fStopPicker = ["1.0", "1.2", "1.4", "1.8", "2.0", "2.8"]
	var shutterspeedSelection = ["1/8000", "1/4000", "1/2000", "1/1000", "1/500", "1/250"]
	
	var body: some View {
		VStack(alignment: .leading) {
			TextField("Camera", text: $cameramodel)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			TextField("Lens", text: $lens)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			TextField("Subject", text: $subject)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			HStack {
				VStack(spacing: 5) {
					Text("Shutterspeed")
					Picker(selection: $shutterspeed, label: Text("Shutterspeed")) {
						ForEach(0 ..< shutterspeedSelection.count) {
							Text(self.shutterspeedSelection[$0])
						}
					}
					.frame(width: UIScreen.main.bounds.size.width/2, height: 100.0)
					.clipped()
				}
				VStack(spacing: 5) {
					Text("f-Stop")
					Picker(selection: $fStop, label: Text("f-Stop")) {
						ForEach(0 ..< fStopPicker.count) {
							Text(self.fStopPicker[$0])
						}
					}
					.frame(width: UIScreen.main.bounds.size.width/2, height: 100.0)
					.clipped()
				}
				.frame(width: UIScreen.main.bounds.size.width/2)
				.clipped()
			}
			TextField("Additional notes", text: $additionalNotes)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			Button(action: addNote) {
				Label("Add Item", systemImage: "plus")
					.foregroundColor(.white)
			}
			Spacer()
		}
		.toolbar {
			#if os(iOS)
			EditButton()
			#endif
			Button(action: addNote) {
				Label("Add Item", systemImage: "plus")
					.foregroundColor(.white)
			}
		}
		.navigationBarTitle(Text("New Note"))
	}
	
	private func addNote() {
		let newNote = Note(context: viewContext)
		let longitude = locationManager.lastLocation?.coordinate.longitude
		let latitude = locationManager.lastLocation?.coordinate.latitude
		
		newNote.timestamp = Date()
		newNote.cameramodel = self.cameramodel
		newNote.lens = self.lens
		newNote.subject = self.subject
		newNote.shutterspeed = self.shutterspeed
		newNote.fStop = self.fStop
		newNote.longitude = longitude!
		newNote.latitude = latitude!
		newNote.id = UUID()
		
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

struct NewNoteView_Previews: PreviewProvider {
	static var previews: some View {
		NewNoteView()
	}
}
