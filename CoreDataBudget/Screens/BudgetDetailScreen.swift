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
	@State private var quantity: Int?
	@State private var selectedTags: Set<Tag> = []
	@State private var expenseToEdit: Expense?
	
	let budget: Budget
	
	private var isFormValid: Bool {
		!title.isEmptyOrWhitespace && 
		amount != nil &&
		Double(amount!) > 0 &&
		!selectedTags.isEmpty &&
		quantity != nil &&
		Int(quantity!) > 0
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
				
				TextField("Quantity", value: $quantity, format: .number)
				
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
							.onLongPressGesture {
								expenseToEdit = expense
							}
					}
					.onDelete(perform: deleteExpense)
					
					VStack(alignment: .leading) {
						HStack{
							Text("Spent")
							Spacer()
							Text(budget.spent, format: .currency(code: Locale.currencyCode))
						}
						
						HStack {
							Text("Remaining")
							Spacer()
							Text(budget.remaining, format: .currency(code: Locale.currencyCode))
								.foregroundStyle(budget.remaining < 0 ? .red : .green)
						}
					}
					.bold()
				}
			}
		}
		.navigationTitle(budget.title ?? "")
		.sheet(item: $expenseToEdit) { expenseToEdit in
			NavigationStack {
				EditExpenseScreen(expense: expenseToEdit)
			}
		}
	}
	
	init(budget: Budget) {
		
		self.budget = budget
		_expenses = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "budget == %@", budget))
	}
	
	private func addExpense() {
		let expense = Expense(context: context)
		expense.title = title
		expense.amount = amount ?? 0.0
		expense.quantity = Int16(quantity ?? 0)
		expense.dateCreated = Date()
		expense.tags = NSSet(array: Array(selectedTags))
		
		budget.addToExpenses(expense)
		
		do {
			try context.save()
			title = ""
			quantity = nil
			amount = nil
			selectedTags = []
		} catch {
			context.rollback()
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


