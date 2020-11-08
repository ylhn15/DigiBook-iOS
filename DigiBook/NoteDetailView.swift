//
//  NoteDetail.swift
//  DigiBook
//
//  Created by Yannick Lehnhausen on 06.11.20.
//

import SwiftUI
import MapKit


struct NoteDetailView: View {
	var note: Note
	
	var body: some View {
		VStack(alignment: .leading) {
			NavigationLink(destination: MapView(note: note)) {
			MapView(note: note)
				.edgesIgnoringSafeArea(.top)
				.frame(height: 150)
				.clipShape(Circle())
				.overlay(
					Circle().stroke(Color.white, lineWidth: 4))
				.shadow(radius: 10)
			}
			Form {
				Section(header: Text("Subject")) {
					Text(note.subject!).font(.title)
				}
				Section(header: Text("Information")) {
					Text(note.cameramodel!).font(.title2)
					Text(note.lens!).font(.title2)
					Text(note.filmtype!).font(.title2)
				}
				Section(header: Text("Settings")) {
					HStack(alignment: .top) {
						Text("\(note.shutterspeed!)s").font(.title3)
						Text("f\(note.fStop!)").font(.title3)
					}
				}
				Text("\(note.additionalNotes!)").font(.title3)
			}
		}
		.padding()
		.navigationBarTitle("\(note.timestamp!, formatter: itemFormatter)").font(.title)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				HStack {
					NavigationLink(destination: NewNoteView(note: self.note)) {
						Text("Edit")
					}
				}
			}
		}
		Spacer()
		
	}
	
	private func editNote() {
		
	}
}


/*struct NoteDetail_Previews: PreviewProvider {
static var previews: some View {
NoteDetail()
}
}*/
