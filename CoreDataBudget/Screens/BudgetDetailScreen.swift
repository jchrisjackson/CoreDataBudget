//
//  BudgetDetailScreen.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/5/24.
//

import SwiftUI

struct BudgetDetailScreen: View {
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
	@State private var title: String = ""
	@State private var amount: Double?
	@State private var selectedTags: Set<Tag> = []
	
	let budget: Budget
	
	private var isFormValid: Bool {
		!title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0 && !selectedTags.isEmpty
	}
	
	private var total: Double {
		expenses.reduce(0) { result, expense in
			expense.amount + result
		}
	}
	
	private var remaining: Double {
		budget.limit - total
	}
	
	var body: some View {
		VStack {
			Text(budget.limit, format: .currency(code: Locale.currencyCode))
				.font(.headline)
				.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
				.padding(.horizontal, 20)
		}
		Form {
			Section("New Expense") {
				TextField("Title", text: $title)
				
				TextField("Amount", value: $amount, format: .number)
					.keyboardType(.numberPad)
				
				TagsView(selectedTags: $selectedTags)
				
				Button {
					addExpense()
				} label: {
					Text("Save")
						.frame(maxWidth: .infinity)
				}
				.buttonStyle(.borderedProminent)
				.disabled(!isFormValid)
			}
			
			Section("Expenses") {
				List {
					ForEach(expenses) { expense in
						ExpenseCellView(expense: expense)
					}
					.onDelete(perform: deleteExpense)
					
					VStack(alignment: .leading) {
						HStack{
							Text("Total")
							Spacer()
							Text(total, format: .currency(code: Locale.currencyCode))
						}
						
						HStack {
							Text("Remaining")
							Spacer()
							Text(remaining, format: .currency(code: Locale.currencyCode))
								.foregroundStyle(remaining < 0 ? .red : .green)
						}
					}
					.bold()
				}
			}
		}
		.navigationTitle(budget.title ?? "")
	}
	
	init(budget: Budget) {
		
		self.budget = budget
		_expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
	}
	
	private func addExpense() {
		let expense = Expense(context: context)
		expense.title = title
		expense.amount = amount ?? 0.0
		expense.dateCreated = Date()
		expense.tags = NSSet(array: Array(selectedTags))
		
		budget.addToExpenses(expense)
		
		do {
			try context.save()
			title = ""
			amount = nil
		} catch {
			print(error.localizedDescription)
		}
	}
	
	private func deleteExpense(_ indexSet: IndexSet) {
		indexSet.forEach { index in
			let expense = expenses[index]
			context.delete(expense)
		}
		
		do {
			try context.save()
		} catch {
			print(error.localizedDescription)
		}
	}
}

struct BudgetDetailScreenPreview: View {
	@FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
	
	var body: some View {
		BudgetDetailScreen(budget: budgets.first(where: { $0.title == "Groceries" })!)
	}
}

#Preview {
	NavigationStack {
		BudgetDetailScreenPreview()
			.environment(\.managedObjectContext, CoreDataProvider.preview.context)
	}
}


