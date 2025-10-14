//
//  ReportViewModel.swift
//  MoneyMate
//
//  Created by Duong on 13/10/25.
//

import Foundation
import CoreData
import UIKit

class ReportViewModel: ReportViewModelProtocol {
    
    var formattedIncome: String = ""
    
    var formattedExpense: String = ""
    
    var formattedBalance: String = ""
    
    var formattedSavingRate: String = ""
    
    
    
    
    
    
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
                
                // Tách income và expense
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
                
            let moneySaving = balance/totalIncome
            let money = (moneySaving*100).rounded() / 100
               
            formattedSavingRate = String(format: "%.0f", money*100) + "%"
            } catch {
                totalIncome = 0
                totalExpense = 0
            }
        }
    func formatCurrency(_ value: Double) -> String {
       let formatter = NumberFormatter()
       formatter.numberStyle = .decimal
       formatter.groupingSeparator = "."
       return formatter.string(from: NSNumber(value: value)) ?? "0"
   }
    
    
}
