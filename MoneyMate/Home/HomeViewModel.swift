//
//  HomeViewModel.swift
//  MoneyMate
//
//  Created by Duong on 12/10/25.
//

import Foundation
import CoreData
import UIKit
class HomeViewModel: HomeViewModelProtocol {
    
    var isDetailButtonShow: Bool = true
    var isNotificationShow: Bool = true
    
    var currentMonth: Date = Date()
    
    
    var formattedIncome: String = ""
    
    var formattedExpense: String = ""
    
    var formattedBalance: String = ""
    
    var dataColectionView: [Category] = []
    
    var onDataUpdated: (() -> Void)?
    
    var listTransaction: [Transaction] = []
    
    func getCategoryByName(_ name: String) -> Category? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        return try? context.fetch(request).first
    }
    
    
    
    func moveToNextMonth() {
        let calendar = Calendar.current
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = nextMonth
        }
        fetchTotals()
        loadListTransaction()
    }
    
    func moveToPreviousMonth() {
        let calendar = Calendar.current
        if let prevMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = prevMonth
        }
        fetchTotals()
        loadListTransaction()
    }
    
    func updateMonthLabel() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentMonth)
        let year = calendar.component(.year, from: currentMonth)
        let monthLable = "Tháng \(month),  \(year)"
        return monthLable
        
    }
    
    
    func numberOfRowsInSection(section: Int) -> Int {
        if listTransaction.count >= 5 {
            return 5
        } else {
            return listTransaction.count
        }
    }
    
    func getStringIcon(index: IndexPath) -> String {
        return (listTransaction[index.row].category?.icon) ?? ""
    }
    
    func getTitle(index: IndexPath) -> String {
        return listTransaction[index.row].note ?? ""
    }
    
    
    func getSubTitle(index: IndexPath) -> String {
        let dateDefault = Date()
        return formatDate(listTransaction[index.row].date ?? dateDefault) + "   -   " + (listTransaction[index.row].category?.name ?? "")
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "dd/MM"
            return dayFormatter.string(from: date)
            
        } else {
            let fullFormatter = DateFormatter()
            fullFormatter.dateFormat = "dd/MM/yyyy"
            return fullFormatter.string(from: date)
        }
    }
    
    func getAmountLable(index: IndexPath) -> String {
        if listTransaction[index.row].type == TransactionType.income.rawValue {
            return "+" + formatCurrency(listTransaction[index.row].amount) + "₫"
        } else {
            return " - " + formatCurrency(listTransaction[index.row].amount) + "₫"
        }
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    
    func getTextColor(index: IndexPath) -> UIColor {
        if listTransaction[index.row].type == TransactionType.income.rawValue {
            return UIColor.green
        } else {
            return UIColor.red
        }
    }
    
    
    
    func deleteTransaction(at indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let transaction = listTransaction[indexPath.row]
        context.delete(transaction)
        listTransaction.remove(at: indexPath.row)
        do {
            try context.save()
        } catch {
            print("\(error)")
        }
        
    }
    
    
    func loadListTransaction() {
        let date = currentMonth
        let calendar = Calendar.current
        
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfMonth as NSDate, endOfMonth as NSDate)
        
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            listTransaction = try context.fetch(request)
            if listTransaction.count <= 5 {
                isDetailButtonShow = true
            } else {
                isDetailButtonShow = false
            }
            if listTransaction.isEmpty == true {
                isNotificationShow = false
            } else {
                isNotificationShow = true
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.onDataUpdated?()
            }
        } catch {
            print("Load list transaction error: \(error)")
        }
        
    }
    
    
    func fetchTotals() {
        
        let date = currentMonth
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        
        var totalIncome: Double = 0
        var totalExpense: Double = 0
        var balance: Double = 0
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfMonth as NSDate, endOfMonth as NSDate)
        
        do {
            let monthlyTransactions = try context.fetch(request)
            totalIncome = monthlyTransactions
                .filter { $0.type == TransactionType.income.rawValue }
                .reduce(0) { $0 + $1.amount }
            
            totalExpense = monthlyTransactions
                .filter { $0.type == TransactionType.expense.rawValue }
                .reduce(0) { $0 + $1.amount }
            
            balance = totalIncome - totalExpense
            formattedIncome = "\(formatCurrency(totalIncome))₫"
            formattedExpense = "\(formatCurrency(totalExpense))₫"
            formattedBalance = "\(formatCurrency(balance))₫"
            
        } catch {
            totalIncome = 0
            totalExpense = 0
        }
    }
    
    func getDataForCollectionView() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let categoryNames = ["Ăn uống", "Xăng xe", "Mua sắm", "Giải trí"]
        
        request.predicate = NSPredicate(format: "name IN %@", categoryNames)
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.localizedCompare(_:)))
        ]
        do {
            dataColectionView = try context.fetch(request)
        } catch {
            print("Get data collectionView error: \(error)")
        }
    }
    
    
    
    
    
}
