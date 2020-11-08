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
			Text("\(note.timestamp ?? Date(), formatter: itemFormatter) \(note.subject ?? "")").font(.title)
			Text("\(note.cameramodel ?? "") \(note.lens ?? "")").font(.subheadline)
		}
    }
}

/*struct NoteRow_Previews: PreviewProvider {
    static var previews: some View {
        NoteRow()
    }
}*/
