//
//  Helper.swift
//  DigiBook
//
//  Created by Yannick Lehnhausen on 06.11.20.
//

import SwiftUI

struct Helper {
    
}

struct Options: Codable, Hashable {
	var options: Array<Dictionary<String,Array<String>>>
}

public let itemFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateStyle = .long
	return formatter
}()

func parseJson() -> Options {
	let url = Bundle.main.url(forResource: "Options", withExtension: "json")!
	let data = try! Data(contentsOf: url)
	let decoder = JSONDecoder()
	let allOptions = try! decoder.decode(Options.self, from: data)
	return allOptions
}


