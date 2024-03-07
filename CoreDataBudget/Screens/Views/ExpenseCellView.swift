//
//  ExpenseCellView.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/7/24.
//

import SwiftUI

struct ExpenseCellView: View {
	let expense: Expense
	
	var body: some View {
		HStack {
			Text(expense.title ?? "")
			Spacer()
			Text(expense.amount, format: .currency(code: Locale.currencyCode))
		}
	}
}

struct ExpenseCellPreview: View {
	@FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
	
	var body: some View {
		ExpenseCellView(expense: expenses[0])
	}
}

#Preview {
	ExpenseCellPreview()
		.environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
