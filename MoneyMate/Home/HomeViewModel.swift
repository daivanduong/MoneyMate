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
    
    var formattedIncome: String = ""
    
    var formattedExpense: String = ""
    
    var formattedBalance: String = ""
    
    
    var onDataUpdated: (() -> Void)?
    
    var listTransaction: [Transaction] = []
    
    
    func loadListTransaction() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        
        request.sortDescriptors = [sort]
          
        do {
            listTransaction =  try context.fetch(request)
            onDataUpdated?()
        } catch {
            print("error: \(error)")
        }
        
    }
    
    
    func numberOfRowsInSection(section: Int) -> Int {
        return listTransaction.count
    }
    
    func getStringIcon(index: IndexPath) -> String {
        return (listTransaction[index.row].category?.icon)!
    }
    
    func getTitle(index: IndexPath) -> String {
        return listTransaction[index.row].note!
    }
    
    
    func getSubTitle(index: IndexPath) -> String {
        return formatDate(listTransaction[index.row].date!) + "   -   " + (listTransaction[index.row].category?.name)!
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
        if listTransaction[index.row].type == "income" {
            return "+" + formatCurrency(listTransaction[index.row].amount) + "đ"
        } else {
            return " - " + formatCurrency(listTransaction[index.row].amount) + "đ"
        }
    }
    
     func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    
    func getTextColor(index: IndexPath) -> UIColor {
        if listTransaction[index.row].type == "income" {
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
            onDataUpdated?()
        } catch {
            print("\(error)")
        }
        
    }
    
    
    func fetchTotals(for month: Int = 10, year: Int = 2025) {
        var totalIncome: Double = 0
        var totalExpense: Double = 0
        var balance: Double = 0
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            let allTransactions = try context.fetch(fetchRequest)
            let calendar = Calendar.current
                // Lọc theo tháng & năm
            let monthlyTransactions = allTransactions.filter { transaction in
                guard let date = transaction.date else { return false }
                    let comps = calendar.dateComponents([.month, .year], from: date)
                    return comps.month == month && comps.year == year
            }
            totalIncome = monthlyTransactions
                .filter { $0.type == "income" }
                .reduce(0) { $0 + $1.amount }
                
            totalExpense = monthlyTransactions
                .filter { $0.type == "expense" }
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
    
    
}
