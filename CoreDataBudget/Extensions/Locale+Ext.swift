//
//  Locale+Ext.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 3/6/24.
//

import Foundation

extension Locale {
	static var currencyCode: String {
		Locale.current.currency?.identifier ?? "USD"
	}
}
