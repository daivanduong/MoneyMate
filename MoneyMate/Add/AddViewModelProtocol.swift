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
    var reLoadPickerView: (() -> Void)? {get set}
    var onSaveSuccess: (() -> Void)? {get set}
    func preloadCategories()
    func fetchCategories(for type: TransactionType) -> [Category]
    
    func updateSegmentIndex(_ index: Int) 
    func selectCategory(at index: Int)
    func getNumberOfRowsInComponent() -> Int
    func getTitleForRow(index: Int) -> String
    func addTransaction(amount: Double, note: String)
    func deleteAllData(entityName: String)
}
