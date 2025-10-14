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
    
    var onSaveSuccess: (() -> Void)?
    var categories: [Category] = []
    var selectedType: TransactionType = .expense
    var selectedCategory: Category?
    var reLoadPickerView: (() -> Void)?
    var selectedDate: Date = Date()
    
    func preloadCategories() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        let count = (try? context.count(for: fetchRequest)) ?? 0
        if count > 0 {
            return
        }
        
        let categories: [(String, String, String)] = [
            ("Ăn uống", "#FF6B6B", "cutlery.png"),
            ("Di chuyển", "#FFA94D", "car.png"),
            ("Nhà ở", "#4ECDC4", "building.png"),
            ("Mua sắm", "#6C63FF", "add-to-cart.png"),
            ("Giải trí", "#FF9F1C", "gamepad.png"),
            ("Sức khỏe", "#2EC4B6", "heart-rate.png"),
            ("Khác", "#9B9B9B", "three-dots.png"),
            ("Lương", "#1DD1A1", "atm-card.png"),
            ("Thưởng", "#48DBFB", "giftbox.png"),
            ("Đầu tư", "#54A0FF", "growth-graph")
        ]
        
        for (name, color, icon) in categories {
            let category = Category(context: context)
            category.id = UUID()
            category.name = name
            category.color = color
            category.icon = icon
        }

        saveContext()
        
    }
    
    
        private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    func updateSegmentIndex(_ index: Int) {
        selectedType = (index == 0) ? .expense : .income
        categories = fetchCategories(for: selectedType)
        reLoadPickerView?()
    }
        
        
    func selectCategory(at index: Int) {
        
        guard index < categories.count else { return }
        selectedCategory = categories[index]
    }
    
    
    
    func fetchCategories(for type: TransactionType) -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
    
        let incomeNames = ["Lương", "Thưởng", "Đầu tư"]
        let expenseNames = ["Ăn uống", "Di chuyển", "Nhà ở", "Mua sắm", "Giải trí", "Sức khỏe", "Khác"]
        
        request.predicate = NSPredicate(format: "name IN %@", type == .income ? incomeNames : expenseNames)
        //request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCompare(_:)))
            ]
        do {
            return try context.fetch(request)
        } catch {
            print("\(error)")
            return []
        }
    }
    
    
    func addTransaction(amount: Double, note: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let transaction = Transaction(context: context)
        transaction.id = UUID()
        transaction.amount = amount
        if (note.isEmpty == false) {
            transaction.note = note
        } else {
            transaction.note = selectedCategory?.name
        }
        
        transaction.date = selectedDate
        transaction.type = selectedType.rawValue     // "income" hoặc "expense"
        transaction.category = selectedCategory
        transaction.createdAt = Date()
        do {
            try context.save()
            DispatchQueue.main.async {
                self.onSaveSuccess?()
            }
        } catch {
            print("Save error: \(error)")
        }      
    }
    
    func deleteAllData(entityName: String) {
        saveContext()
    }
    
    func saveContext() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func getNumberOfRowsInComponent() -> Int {
        return categories.count
    }
    
    func getTitleForRow(index: Int) -> String {
        return categories[index].name!
    }
    
}
