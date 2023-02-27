//
//  ToDo.swift
//  ToDo
//
//  Created by Mikkel Hauge on 17/02/2023.
//

import Foundation

struct ToDo: Identifiable, Codable {
	let id = UUID()
	let title: String
	let description: String
	var completed: Bool
	var createdDate: Date
	
	
	init(title: String, description: String, completed: Bool = false, createdDate: Date = Date()) {
		self.title = title
		self.description = description
		self.completed = completed
		self.createdDate = createdDate
	}
		
	enum CodingKeys: String, CodingKey {
		case title
		case description
		case completed
		case createdDate
	}
		
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.title = try container.decode(String.self, forKey: .title)
		self.description = try container.decode(String.self, forKey: .description)
		self.createdDate = try container.decode(Date.self, forKey: .createdDate)
			
		// Set the value of `completed` manually based on the presence of the `completed` key
		if container.contains(.completed) {
			self.completed = try container.decode(Bool.self, forKey: .completed)
		} else {
			self.completed = false
		}
		print("Converting todo: \(title)")
	}
}

