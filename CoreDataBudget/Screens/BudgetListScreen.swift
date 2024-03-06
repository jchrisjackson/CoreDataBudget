//
//  BudgetListScreen.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 2/22/24.
//

import SwiftUI

struct BudgetListScreen: View {
	@FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
	@State private var isPresented: Bool = false
	
	var body: some View {
		VStack {
			List(budgets) { budget in
				NavigationLink {
					BudgetDetailScreen(budget: budget)
				} label: {
					BudgetCellView(budget: budget)
				}
			}
		}
		.navigationTitle("Budget App")
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button("Add Budget") {
					isPresented = true
				}
			}
		}
		.sheet(isPresented: $isPresented) {
			AddBudgetScreen()
		}
	}
}

struct BudgetCellView: View {
	let budget: Budget
	
	var body: some View {
		HStack {
			Text(budget.title ?? "")
			Spacer()
			Text(budget.limit, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
		}
	}
}

#Preview {
	NavigationStack {
		BudgetListScreen()
	}
	.environment(\.managedObjectContext, CoreDataProvider.preview.context)
}

