//
//  ToDoListViewModel.swift
//  ToDo
//
//  Created by Mikkel Hauge on 17/02/2023.
//

import SwiftUI
import Foundation

class ToDoListViewModel: ObservableObject {
	@Published private(set) var toDos = [ToDo](){
		didSet {
			saveToDoList()
		}
	}
	
	@Published public var filterCompleted = false
	
	private let todoListKey = "ToDos"
	
	init() {
		loadToDoList()
	}
	
	private let fileURL = FileManager.default
			.urls(for: .documentDirectory, in: .userDomainMask)
			.first!
			.appendingPathComponent("ToDos.json")

	
	private func saveToDoList() {
		do {
			let data = try JSONEncoder().encode(toDos)
			try data.write(to: fileURL)
			print("saving todolist...")
		} catch {
			print("Error saving to-do list: \(error)")
		}
	}
	
	private func loadToDoList() {
		do {
			let data = try Data(contentsOf: fileURL)
			let decoder = JSONDecoder()
			let decoded = try decoder.decode([ToDo].self, from: data)
			toDos = decoded
			print("loading todolist...")
		} catch {
			print("Error loading to-do list: \(error)")
		}
	}


	var filteredToDos: [ToDo] {
			if filterCompleted {
				return toDos.filter { $0.completed }
			} else {
				return toDos
			}
		}
	
	func add(_ toDo: ToDo) {
		toDos.append(toDo)
		saveToDoList()
	}
	
	func remove(_ todo: ToDo) {
			if let index = toDos.firstIndex(where: { $0.id == todo.id }) {
				toDos.remove(at: index)
			}
		}
 
	func toggleCompletion(for toDo: ToDo) {
		if let index = toDos.firstIndex(where: { $0.id == toDo.id }) {
			toDos[index].completed.toggle()
		}
	}
}
