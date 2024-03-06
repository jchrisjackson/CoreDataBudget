//
//  BudgetDetailScreen.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/5/24.
//

import SwiftUI

struct BudgetDetailScreen: View {
	@State private var title: String = ""
	@State private var amount: Double?
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
	
	
	
	let budget: Budget
	
	private var isFormValid: Bool {
		!title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0
	}
	
	private var total: Double {
		expenses.reduce(0) { result, expense in
			expense.amount + result
		}
	}
	
	var body: some View {
		Form {
			Section("New Expense") {
				TextField("Title", text: $title)
				
				TextField("Amount", value: $amount, format: .number)
					.keyboardType(.numberPad)
				
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
					Text(total, format: .currency(code: Locale.currencyCode))
					
					ForEach(expenses) { expense in
						HStack {
							Text(expense.title ?? "")
							Spacer()
							Text(expense.amount, format: .currency(code: Locale.currencyCode))
						}
					}
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
		
		budget.addToExpenses(expense)
		
		do {
			try context.save()
			title = ""
			amount = nil
		} catch {
			print(error.localizedDescription)
		}
	}
}

struct BudgetDetailScreenContainer: View {
	@FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
	var body: some View {
		BudgetDetailScreen(budget: budgets.first(where: { $0.title == "Groceries" })!)
	}
}

#Preview {
	NavigationStack {
		BudgetDetailScreenContainer()
			.environment(\.managedObjectContext, CoreDataProvider.preview.context)
	}
}