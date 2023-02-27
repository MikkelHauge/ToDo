//
//  ToDoApp.swift
//  ToDo
//
//  Created by Mikkel Hauge on 17/02/2023.
//
import SwiftUI

@main
struct ToDoApp: App {
	@StateObject private var appState = ToDoListViewModel()

    var body: some Scene {
        WindowGroup {
			ToDoListView().environmentObject(appState)
		}
    }
}
