//
//  MigrationPolicy_V1_to_V2.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/18/24.
//

import Foundation
import CoreData

class MigrationPolicy_V1_to_V2: NSEntityMigrationPolicy {
	override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
		var titles: [String] = []
		var index: Int = 1
		let context = manager.sourceContext
		let expenseRequest = Expense.fetchRequest()
		let results: [NSManagedObject] = try context.fetch(expenseRequest)
		
		for result in results {
			guard let title = result.value(forKey: "title") as? String else { continue }
			if !title.contains(title) {
				titles.append(title)
			} else {
				
				// delete the duplicate
//				context.delete(result)
				
				// it is a duplicate title
				let uniqueTitle = title + "\(index)"
				index += 1
				result.setValue(uniqueTitle, forKey: "title")
			}
		}
	}
}
