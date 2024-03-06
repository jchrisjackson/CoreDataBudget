//
//  CoreDataProvider.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 2/22/24.
//

import Foundation
import CoreData

class CoreDataProvider {
	let persistentContainer: NSPersistentContainer
	
	var context: NSManagedObjectContext {
		persistentContainer.viewContext
	}
	
	static var preview: CoreDataProvider = {
		let provider = CoreDataProvider(inMemory: true)
		let context = provider.context
		
		let entertainment = Budget(context: context)
		entertainment.title = "Entertainment"
		entertainment.limit = 500
		entertainment.dateCreated = Date()
		
		let groceries = Budget(context: context)
		groceries.title = "Groceries"
		groceries.limit = 200
		groceries.dateCreated = Date()
		
		let milk = Expense(context: context)
		milk.title = "Milk"
		milk.amount = 5.45
		milk.dateCreated = Date()
		
		
		let cookies = Expense(context: context)
		cookies.title = "Cookies"
		cookies.amount = 8.45
		cookies.dateCreated = Date()
		
		groceries.addToExpenses(milk)
		groceries.addToExpenses(cookies)
		
		do {
			try context.save()
		} catch {
			print(error.localizedDescription)
		}
		
		return provider
	}()
	
	init(inMemory: Bool = false) {
		persistentContainer = NSPersistentContainer(name: "BudgetModel")
		
		if inMemory {
			persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		
		persistentContainer.loadPersistentStores { _, error in
			if let error {
				fatalError("Core Data store failed to initialize \(error.localizedDescription)")
			}
		}
	}
}
