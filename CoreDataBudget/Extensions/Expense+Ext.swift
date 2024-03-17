//
//  Expense+Ext.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/17/24.
//

import Foundation
import CoreData

extension Expense {
	var total: Double {
		amount * Double(quantity)
	}
}
