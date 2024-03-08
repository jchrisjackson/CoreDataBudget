//
//  TagsSeeder.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/8/24.
//

import Foundation
import CoreData

class TagsSeeder {
	private var context: NSManagedObjectContext
	
//	let commonTags = ["Food", "Dining", "Travel", "Entertainment", "Shopping", "Transportation", "Utilities", "Groceries", "Health", "Eductation"]
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	func seed(_ commonTags: [String]) throws {
		for commonTag in commonTags {
			let tag = Tag(context: context)
			tag.name = commonTag
			
			try context.save()
//			do {
//				try context.save()
//			} catch {
//				print(error.localizedDescription)
//			}
		}
	}
}
