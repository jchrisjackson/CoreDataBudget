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
	@State private var isFilteredPresented: Bool = false
	
	private var totalBudget: Double {
		budgets.reduce(0) { limit, budget in
			budget.limit + limit
		}
	}
	
	var body: some View {
		VStack {
			if budgets.isEmpty {
				ContentUnavailableView("No budgets available", systemImage: "list.clipboard")
			} else {
				List {
					HStack {
						Text("Total Budget")
						Spacer()
						Text(totalBudget, format: .currency(code: Locale.currencyCode))
					}
					.font(.headline)
					
					ForEach(budgets) { budget in
						NavigationLink {
							BudgetDetailScreen(budget: budget)
						} label: {
							BudgetCellView(budget: budget)
						}
					}
				}
			}
		}
		.overlay(alignment: .bottom) {
			Button("Filter") {
				isFilteredPresented = true
			}
			.buttonStyle(.borderedProminent)
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
		.sheet(isPresented: $isFilteredPresented) {
			NavigationStack {
				FilterScreen()
			}
		}
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

