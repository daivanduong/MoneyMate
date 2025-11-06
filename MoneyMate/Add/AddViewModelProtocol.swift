//
//  AddViewModelProtocol.swift
//  MoneyMate
//
//  Created by Duong on 12/10/25.
//

import Foundation

enum TransactionType: String {
    case expense = "expense"
    case income = "income"
}


protocol AddViewModelProtocol {
    
    var categories: [Category] {get set}
    var selectedType: TransactionType {get set}
    var selectedCategory: Category? {get set}
    var selectedDate: Date {get set}
    var onSaveSuccess: (() -> Void)? {get set}
    var backToHomeScreen: (() -> Void)? {get set}
    func fetchCategories(for type: TransactionType) -> [Category]
    func updateSegmentIndex(_ index: Int)
    func selectCategory(at index: Int)
    func addNewTransaction(amount: Double, note: String)
}
