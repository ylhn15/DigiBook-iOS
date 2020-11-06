//
//  NoteDetail.swift
//  DigiBook
//
//  Created by Yannick Lehnhausen on 06.11.20.
//

import SwiftUI
import MapKit


struct NoteDetail: View {
	var note: Note
	
	var body: some View {
		MapView(note: note)
		VStack(alignment: .leading) {
			Text(note.subject!).font(.title)
			Divider()
			Text(note.cameramodel!).font(.title2)
			Text(note.lens!).font(.title2)
			Divider()
			HStack(alignment: .top) {
				Text("\(note.shutterspeed!)s").font(.title3)
				Text("f\(note.fStop!)").font(.title3)
			}
		}
		Spacer()
			.navigationTitle("\(note.timestamp!, formatter: itemFormatter)").font(.title)

	}
}

private let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .short
	return formatter
}()

/*struct NoteDetail_Previews: PreviewProvider {
static var previews: some View {
NoteDetail()
}
}*/
