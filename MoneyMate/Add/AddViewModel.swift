//
//  AddViewModel.swift
//  MoneyMate
//
//  Created by Duong on 12/10/25.
//

import Foundation
import CoreData
import UIKit

class AddViewModel: AddViewModelProtocol {
    
    
    var backToHomeScreen: (() -> Void)?
    var onSaveSuccess: (() -> Void)?
    var categories: [Category] = []
    var selectedType: TransactionType = .expense
    var selectedCategory: Category?
    var selectedDate: Date = Date()
    
    func updateSegmentIndex(_ index: Int = 0) {
        selectedType = (index == 0) ? .expense : .income
        categories = fetchCategories(for: selectedType)
    }
    
    func selectCategory(at index: Int) {
        guard index < categories.count else { return }
        selectedCategory = categories[index]
    }
        
    func fetchCategories(for type: TransactionType) -> [Category] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let incomeNames = ["Lương", "Thưởng", "Đầu tư"]
        let expenseNames = ["Ăn uống", "Di chuyển", "Nhà ở", "Mua sắm", "Xăng xe", "Giải trí", "Sức khỏe", "Khác"]
        
        request.predicate = NSPredicate(format: "name IN %@", type == .income ? incomeNames : expenseNames)
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCompare(_:)))
        ]
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch categories error:\(error)")
            return []
        }
    }
    
    func addNewTransaction(amount: Double, note: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        if (note.isEmpty == true) {
            transaction.note = selectedCategory?.name
            
        } else {
            transaction.note = note
        }
        
        transaction.date = selectedDate
        transaction.type = selectedType.rawValue
        transaction.category = selectedCategory
        
        
        transaction.createdAt = Date()
        do {
            try context.save()
            DispatchQueue.main.async {
                self.onSaveSuccess?()
            }
        } catch {
            print("Add new transaction error: \(error)")
        }
    }
    
}
