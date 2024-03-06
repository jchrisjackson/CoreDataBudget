//
//  String+Ext.swift
//  CoreDataBudget
//
//  Created by Chris Jackson on 2/22/24.
//

import Foundation

extension String {
	var isEmptyOrWhitespace: Bool {
		trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
}
