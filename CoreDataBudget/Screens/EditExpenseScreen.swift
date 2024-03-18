//
//  EditExpenseScreen.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/18/24.
//

import SwiftUI

struct EditExpenseScreen: View {
	@Environment(\.managedObjectContext) private var context
	@Environment(\.dismiss) private var dismiss
	
	@State private var expenseTitle: String = ""
	@State private var expenseAmount: Double?
	@State private var expenseQuantity: Int = 0
	@State private var expenseSelectedTags: Set<Tag> = []
	
	let expense : Expense
	
	var body: some View {
		Form {
			TextField("Title", text: $expenseTitle)
			TextField("Amount", value: $expenseAmount, format: .number)
			TextField("Quantity", value: $expenseQuantity, format: .number)
			TagsView(selectedTags: $expenseSelectedTags)
		}
		.navigationTitle(expense.title ?? "")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Update") {
					updateExpense()
				}
			}
		}
		.onAppear {
			expenseTitle = expense.title ?? ""
			expenseAmount = expense.amount
			expenseQuantity = Int(expense.quantity)
			
			if let tags = expense.tags {
				expenseSelectedTags = Set(tags.compactMap { $0 as? Tag })
			}
		}
	}
	
	private func updateExpense() {
		expense.title = expenseTitle
		expense.amount = expenseAmount ?? 0.0
		expense.quantity = Int16(expenseQuantity)
		expense.tags = NSSet(array: Array(expenseSelectedTags))
		
		do {
			try context.save()
			dismiss()
		} catch {
			print(error.localizedDescription)
		}
	}
}

struct EditExpenseScreenPreview: View {
	@FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
	
	var body: some View {
		NavigationStack {
			EditExpenseScreen(expense: expenses[0])
		}
	}
}

#Preview {
	EditExpenseScreenPreview()
		.environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
