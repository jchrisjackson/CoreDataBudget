//
//  FilterScreen.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/13/24.
//

import SwiftUI

struct FilterScreen: View {
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
	@State private var selectedTags: Set<Tag> = []
	@State private var filteredExpenses: [Expense] = []
	
	var body: some View {
		VStack {
			TagsView(selectedTags: $selectedTags)
				.onChange(of: selectedTags, filterTags)
			
			List(filteredExpenses) { expense in
				ExpenseCellView(expense: expense)
			}
			
			Spacer()
			
			HStack {
				Spacer()
				
				Button("Show All") {
					selectedTags = []
					filteredExpenses = expenses.map { $0 }
				}
				
				Spacer()
			}
		}
		.padding()
		.navigationTitle("Filter")
	}
	
	private func filterTags() {
		if selectedTags.isEmpty {
			return
		}
		
		let selectedTagNames = selectedTags.map { $0.name }
		let request = Expense.fetchRequest()
		request.predicate = NSPredicate(format: "ANY tags.name IN %@", selectedTagNames)
		
		do {
			filteredExpenses = try context.fetch(request)
		} catch {
			print(error.localizedDescription)
		}
	}
}

#Preview {
	NavigationStack {
		FilterScreen()
			.environment(\.managedObjectContext, CoreDataProvider.preview.context)
	}
}
