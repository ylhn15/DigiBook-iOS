//
//  ContentView.swift
//  DigiBook
//
//  Created by Yannick Lehnhausen on 06.11.20.
//

import SwiftUI
import CoreData

struct ContentView: View {
	@ObservedObject var locationManager = LocationManager()
	@Environment(\.managedObjectContext) private var viewContext
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)],
		animation: .default)
	private var notes: FetchedResults<Note>
	
	var body: some View {
		NavigationView {
			List {
				NavigationLink(destination: NewNoteView()) {
					Label("New Note", systemImage: "plus")
				}
				ForEach(notes) { note in
					NavigationLink(destination: NoteDetailView(note: note)) {
						NoteRow(note: note)
					}
				}
				.onDelete(perform: deleteItems)
			}
			.toolbar {
				#if os(iOS)
				EditButton()
				#endif
			}
			.navigationBarTitle(Text("Notes"))
		}
	}
	
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			offsets.map { notes[$0] }.forEach(viewContext.delete)
			
			do {
				try viewContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
	}
}
