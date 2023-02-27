import SwiftUI
import Foundation

struct ToDoListView: View {
	@EnvironmentObject var toDoViewModel: ToDoListViewModel
	@State private var isShowingAddToDoView = false
	@State private var filterOption = FilterOption.all
	
	enum FilterOption {
		case all
		case completed
		case uncompleted
	}
	
	var toDoList: [ToDo] {
		switch filterOption {
		case .completed:
			return toDoViewModel.toDos.filter { $0.completed }
				.sorted(by: { $0.createdDate > $1.createdDate })
		case .uncompleted:
			return toDoViewModel.toDos.filter { !$0.completed }
				.sorted(by: { $0.createdDate > $1.createdDate })
		default:
			return toDoViewModel.toDos
				.sorted(by: { $0.createdDate > $1.createdDate })
		}
	}
	
	var body: some View {
		NavigationView {
			List {
				ForEach(toDoList) { todo in
					HStack {
						Button(action: {
							toDoViewModel.toggleCompletion(for: todo)
						}) {
							Image(systemName: todo.completed ? "checkmark.square.fill" : "square")
						}
						.buttonStyle(BorderlessButtonStyle())
						
						NavigationLink(destination: ToDoDetailView(todo: todo, viewModel: toDoViewModel)) {
							HStack{
								VStack(alignment: .leading) {
									Text(todo.title)
										.strikethrough(todo.completed, color: .gray)
										.lineLimit(1)
									if !todo.description.isEmpty {
										Text(String(todo.description.prefix(20)))
											.foregroundColor(.gray)
											.font(.caption)
											.lineLimit(1)
									}
								}
								HStack{
									Spacer()
									
									Text(formatDate(date: todo.createdDate))
										.frame(alignment: .trailing)
								}
								
							}
						}
					}
				}.onDelete { indexSet in
					let indexArray = indexSet.map { $0 }
					let toDosToDelete = indexArray.map { toDoViewModel.toDos[$0] }
					for toDo in toDosToDelete {
						toDoViewModel.remove(toDo)
					}
				}
				
			}.navigationBarTitle("To-Do")
				.navigationBarItems(
					leading: Picker(selection: $filterOption, label: Text("Show:")){
						Text("All").tag(FilterOption.all)
						Text("Completed").tag(FilterOption.completed)
						Text("Uncompleted").tag(FilterOption.uncompleted)
					}.pickerStyle(.inline)
					,
					trailing: Button(action: { self.isShowingAddToDoView = true }) {
						Image(systemName: "plus")
					}
				)
				.sheet(isPresented: $isShowingAddToDoView) {
					AddToDoView()
						.environmentObject(toDoViewModel)
				}
			
			
		}
	}
}

struct ToDoListView_Previews: PreviewProvider {
	
	
	static var previews: some View {
		let toDoViewModel = ToDoListViewModel()
		toDoViewModel.add(ToDo(title: "Æd bøf 🥩", description: "with butter", completed: false, createdDate: Date()))
		toDoViewModel.add(ToDo(title: "Banan 🍌", description: "friturestegt", completed: true, createdDate: Date()))
		toDoViewModel.add(ToDo(title: "Vask bil 🚙", description: "                 1234567890 1234567890 1234567890 12345678901234567890", completed: false, createdDate: Date()))
		
		return ToDoListView()
			.environmentObject(toDoViewModel)
	}
}


struct rowView: View {
	@EnvironmentObject var toDoViewModel: ToDoListViewModel
	
	@Binding var todo:ToDo
	
	var body: some View {
		HStack {
			Button(action: {
				toDoViewModel.toggleCompletion(for: todo)
			}) {
				Image(systemName: todo.completed ? "checkmark.square.fill" : "square")
			}
			.buttonStyle(BorderlessButtonStyle())
			NavigationLink(destination: ToDoDetailView(todo: todo, viewModel: toDoViewModel)) {
				VStack(alignment: .leading) {
					Text(todo.title)
						.strikethrough(todo.completed, color: .black)
					if !todo.description.isEmpty {
						Text(todo.description)
							.foregroundColor(.gray)
							.font(.caption)
					}
				}
				HStack{
					Spacer()
					
					Text("date")
						.frame(alignment: .center)
				}
			}
		}
	}
}

func formatDate(date: Date) -> String {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "MM/dd" // Format for older dates
	
	if Calendar.current.isDateInToday(date) {
		dateFormatter.dateFormat = "HH:mm" // Format for today's date
	}
	
	return dateFormatter.string(from: date)
}

