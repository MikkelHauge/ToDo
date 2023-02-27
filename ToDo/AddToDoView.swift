import SwiftUI

struct AddToDoView: View {
	@EnvironmentObject var toDoViewModel: ToDoListViewModel
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.dismiss) var dismissWindow

	@State private var title = ""
	@State private var description = ""
	
	var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Title", text: $title)
					TextField("Description", text: $description)
				}
			
				Section {
					Button(action: {
						let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
						let toDo = ToDo(title: title, description: trimmed, createdDate: Date())
						toDoViewModel.add(toDo)
						presentationMode.wrappedValue.dismiss()
					}) {
						Text("Add To-Do")
					}
					
					Button{
						dismissWindow()
					} label: {
						HStack{
							Spacer()
							Text("Cancel")
								.foregroundColor(.red)
							
						}
					}
				}
			}
			.navigationBarTitle("Create To-Do")
		}
	}
}

struct AddToDoView_Previews: PreviewProvider {
	static var previews: some View {
		AddToDoView()
	}
}
