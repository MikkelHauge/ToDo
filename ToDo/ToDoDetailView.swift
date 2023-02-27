import SwiftUI

struct ToDoDetailView: View {
	let todo: ToDo
	let viewModel: ToDoListViewModel
	
	var body: some View {
		VStack {
			Text(todo.title)
				.font(.largeTitle)
			
			Spacer()
			
			if !todo.description.isEmpty {
				Text(todo.description)
					.font(.subheadline)
			}
			Spacer()
			Spacer()
			Spacer()
			Spacer()
			
			HStack{
				Text("Oprettet: ")
				
				Text(formatDate(date: todo.createdDate))
			}

		}
		.padding()
		.navigationBarTitle(Text("To-Do Detail"), displayMode: .inline)
		.navigationBarItems(trailing: Button(action: {
			viewModel.remove(todo)
		}) {
			Image(systemName: "trash")
		})
	}
}

struct ToDoDetailView_Previews: PreviewProvider {
	static var previews: some View {
		let viewModel = ToDoListViewModel()
		let todo = ToDo(title: "Buy groceries", description: "hestekød", createdDate: Date())
		viewModel.add(todo)
		return NavigationView {
			ToDoDetailView(todo: todo, viewModel: viewModel)
		}
	}
}
