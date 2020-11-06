//
//  NoteRow.swift
//  DigiBook
//
//  Created by Yannick Lehnhausen on 06.11.20.
//

import SwiftUI

struct NoteRow: View {
	var note: Note
	
    var body: some View {
		VStack(alignment: .leading) {
			Text("\(note.timestamp!, formatter: itemFormatter) \(note.subject!)").font(.title)
			Text("\(note.cameramodel!) \(note.lens!)").font(.subheadline)
		}
    }
}

private let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .short
	return formatter
}()

/*struct NoteRow_Previews: PreviewProvider {
    static var previews: some View {
        NoteRow()
    }
}*/
