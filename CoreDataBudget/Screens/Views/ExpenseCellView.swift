//
//  ExpenseCellView.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/7/24.
//

import SwiftUI

struct ExpenseCellView: View {
	@ObservedObject var expense: Expense
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(expense.title ?? "")
				Text("(\(expense.quantity))")
				Spacer()
				Text(expense.total, format: .currency(code: Locale.currencyCode))
			}
			.contentShape(Rectangle())
			
			ScrollView(.horizontal) {
				HStack {
					ForEach(Array(expense.tags as? Set<Tag> ?? [])) { tag in
						Text(tag.name ?? "")
							.font(.caption)
							.padding(6)
							.foregroundStyle(.white)
							.background(.blue)
							.clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
					}
				}
			}
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
