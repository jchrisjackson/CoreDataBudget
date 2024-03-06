//
//  CoreDataBudgetApp.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 2/22/24.
//

import SwiftUI

@main
struct CoreDataBudgetApp: App {
	let provider: CoreDataProvider
	
	init() {
		provider = CoreDataProvider()
	}
	
	var body: some Scene {
		WindowGroup {
			BudgetListScreen()
				.environment(\.managedObjectContext, provider.context)
		}
	}
}
